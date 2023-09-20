//
//  CallView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/07/29.
//

import SwiftUI
import SDWebImageSwiftUI
import AmazonChimeSDK

// ホストの通話画面
struct HostCallView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var appState: AppState
    @ObservedObject var realTimeCall = RealTimeCallStatus.shared
    @StateObject var viewModel = HostCallViewModel()
    @FocusState var focus
    @Binding var channelTitle: String
    let user: UserObservableModel
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ZStack {
                    VStack {
                        Text(channelTitle)
                            .foregroundColor(.customBlack)
                            .font(.system(size: 16, weight: .medium))
                        LottieView(animationResourceName: "calling", loopMode: .loop, isActive: true)
                            .frame(width: 120, height: 120)
                        Text("通話ルームを作成しています。少々お待ちください。")
                            .foregroundColor(.customBlack)
                            .font(.system(size: 14))
                            .padding(.top, 24)
                    }
                }
            } else {
                VStack(spacing: .zero){
                    ZStack {
                        VStack {
                            if let call = viewModel.call {
                                Text(call.call.channelTitle)
                                    .foregroundColor(.white)
                                    .font(.system(size: 16, weight: .medium))
                                LazyVGrid(columns: Array(repeating: .init(), count: 3), spacing: 10) {
                                    ForEach(Array<String>(call.call.userIdToUserIconImageUrlString.keys), id: \.self){ userId in
                                        VStack {
                                            if let profileImage = call.call.userIdToUserIconImageUrlString[userId], !profileImage.isEmpty {
                                                Image(call.call.userIdToUserIconImageUrlString[userId] ?? "")
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: 70, height: 70)
                                                    .background(Color.gray.opacity(0.1))
                                                    .clipShape(Circle())
                                                    .overlay {
                                                        Circle()
                                                            .stroke(Color.customRed.opacity((realTimeCall.scores[userId] ?? 0)*2), lineWidth: 3)
                                                    }
                                            }
                                            
                                            Text(call.call.userIdToUserName[userId] ?? "")
                                                .foregroundColor(.customBlack)
                                                .font(.system(size: 16))
                                        }
                                    }
                                }
                                .navigationTitle(Array<String>(
                                    call.call.userIdToUserName.keys).count == 1 ? "他の参加者を待っています...": "通話中")
                                .padding(.top, 16)
                            }
                            Spacer()
                            CallBottomBar(
                                isMuted: viewModel.isMuted,
                                isMutedAction: {
                                    viewModel.muteAudio()
                                },
                                isSpeaker: viewModel.isSpeaker,
                                isOutputRouterAction: {
                                    viewModel.changeOutputRoute()
                                },
                                leaveAction: {
                                    viewModel.isAlertDeleteCall = true
                                })
                        }
                    }
                }
            }
        }
        .onTapGesture {
            self.focus = false
        }
        .onAppear {
            if appState.isHostCallReload {
                viewModel.startCalling(
                    user: user,
                    channelTitle: channelTitle
                )
                appState.isHostCallReload = false
            }
        }
        .navigationBarBackButtonHidden()
        .onReceive(viewModel.$isSuccessDeleteCall){
            if $0 { dismiss() }
        }
        .onReceive(realTimeCall.$dropUser){ dropUsers in
            guard let call = viewModel.call else { return }
            if dropUsers.contains(call.call.hostUserId) {
                viewModel.finishChannel(
                    callInfo: call,
                    appState: appState
                )
            } else {
                if let dropUser = dropUsers.last {
                    viewModel.updateAttendeeCallStatus(userId: dropUser, channelId: viewModel.channelId)
                }
            }
        }
        .alert(isPresented: $viewModel.isAlertDeleteCall) {
            Alert(title: Text("終了しますか？"),
                  message: Text("あなたはホストです。終了すると、全てのユーザーは通話から離脱されます。"),
                  primaryButton: .default(
                    Text("終了する"), action: {
                        if let call = viewModel.call {
                            viewModel.finishChannel(callInfo: call, appState: appState)
                        }
                    }),
                  secondaryButton: .default(Text("キャンセル")))
        }
    }
}

