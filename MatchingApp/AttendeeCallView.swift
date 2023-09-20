//
//  AttendeeCallView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/08/19.
//

import SwiftUI
import SDWebImageSwiftUI

// ホスト以外の参加者の通話画面
struct AttendeeCallView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var appState: AppState
    @StateObject var viewModel = AttendeeCallViewModel()
    @ObservedObject var realTimeCall = RealTimeCallStatus.shared
    let user: UserObservableModel
    let channelId: String
    
    var body: some View {
        VStack {
            if viewModel.isLoading {
                ZStack {
                    VStack {
                        LottieView(animationResourceName: "calling", loopMode: .loop, isActive: true)
                            .frame(width: 120, height: 120)
                        Text("通話ルームに接続しています。少々お待ちください。")
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .medium))
                    }
                }
            } else {
                if let call = viewModel.call {
                    VStack {
                        Text(call.call.channelTitle)
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .medium))
                        LazyVGrid(columns: Array(repeating: .init(), count: 3), spacing: 10) {
                            ForEach(Array<String>(call.call.userIdToUserIconImageUrlString.keys), id: \.self){ userId in
                                VStack {
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
                                    
                                    Text(call.call.userIdToUserName[userId] ?? "")
                                        .foregroundColor(.white)
                                        .font(.system(size: 16))
                                }
                            }
                        }
                        .padding(.top, 16)
                        Spacer()
                        CallBottomBar(
                            isMuted: viewModel.isMuted,
                            isMutedAction: { viewModel.muteAudio() },
                            isSpeaker: viewModel.isSpeaker,
                            isOutputRouterAction: { viewModel.changeOutputRouter() },
                            leaveAction: {
                                self.viewModel.alertType = .leaveWarning
                                self.viewModel.isAlert = true
                            }
                        )
                    }
                }
            }
        }
        .navigationBarBackButtonHidden()
        .navigationTitle("通話ルーム")
        .alert(isPresented: $viewModel.isAlert){
            switch viewModel.alertType {
            case .connectionFatalWarning:
                return Alert(
                    title: Text("通話エラー"),
                    message: Text("すでに終了された通話です。"),
                    dismissButton: .default(Text("戻る"), action: {
                        appState.isAttendeeCallReload = true
                        dismiss()
                    })
                )
            case .leaveHost:
                return Alert(
                    title: Text("ホストが終了しました。"),
                    message: Text("すでに終了された通話です。"),
                    dismissButton: .default(Text("戻る"), action: {
                        appState.isAttendeeCallReload = true
                        dismiss()
                    })
                )
            case .leaveWarning:
                return Alert(
                    title: Text("退出しますか？"),
                    message: Text("通話を途中で退出します。"),
                    primaryButton: .default(
                        Text("退出する"), action: {
                            viewModel.leaveChannelAndUpdateAttendeeCallStatus(
                                userId: user.user.uid,
                                channelId: channelId
                            )
                            appState.isAttendeeCallReload = true
                            dismiss()
                        }),
                    secondaryButton: .default(Text("キャンセル")))
            }
        }
        .onAppear {
            if appState.isAttendeeCallReload {
                viewModel.joinCall(channelId: channelId, userModel: user)
                appState.isAttendeeCallReload = false
            }
        }
        .onReceive(viewModel.$isFinishedCall) {
            if $0 {
                viewModel.leaveChannelAndUpdateAttendeeCallStatus(
                    userId: user.user.uid,
                    channelId: channelId
                )
                viewModel.alertType = .leaveHost
                viewModel.isAlert = true
            }
        }
        .onReceive(realTimeCall.$dropUser) { dropUsers in
            guard let call = viewModel.call else { return }
            if dropUsers.contains(call.call.hostUserId) {
                viewModel.finishChannel(
                    callInfo: call,
                    appState: appState
                )
            }
        }
    }
}
