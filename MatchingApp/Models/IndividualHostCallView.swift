//
//  IndividualHostCallView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/08/30.
//

import SwiftUI
import SDWebImageSwiftUI

struct IndividualHostCallView: View {
    @StateObject var viewModel = IndividualHostCallViewModel()
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var appState: AppState
    let chatRoomId: String
    let messageId: String
    let fromUser: UserObservableModel
    let toUser: UserObservableModel
    
    var body: some View {
        ZStack {
            if viewModel.isLoading {
                VStack {
                    Text(toUser.user.nickname)
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .medium))
                    LottieView(animationResourceName: "calling", loopMode: .loop, isActive: true)
                        .frame(width: 120, height: 120)
                    Text("通話ルームを作成しています。少々お待ちください。")
                        .foregroundColor(.customBlack)
                        .font(.system(size: 14))
                        .padding(.top, 24)
                }
            } else {
                VStack {
                    Image(toUser.user.profileImageURLString)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 128, height: 128)
                        .background(Color.gray.opacity(0.1))
                        .clipShape(Circle())
                        .overlay {
                            Circle()
                                .stroke(.white, lineWidth: 2)
                        }
                    
                    Text(toUser.user.nickname)
                        .foregroundColor(.customBlack)
                        .font(.system(size: 24, weight: .medium))
                        .padding(.top, 8)
                   
                    Text(viewModel.isWaitingText)
                        .foregroundColor(.customBlack)
                        .font(.system(size: 16, weight: .medium))
                        .padding(.top, 8)
                    
                    VStack(alignment: .leading) {
                        Label {
                            Text("通話のルール")
                                .foregroundColor(.customBlack)
                                .font(.system(size: 24, weight: .medium))
                        } icon: {
                            Image(systemName: "exclamationmark.bubble.fill")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.yellow)
                        }
                        .padding(.top, 16)

                        ForEach(callGuideLines) { guideline in
                            VStack(alignment: .leading){
                                Text(guideline.text)
                                    
                                Text(guideline.description)
                            }
                            .foregroundColor(.customBlack)
                        }
                        Spacer()
                    }
                    .frame(width: UIScreen.main.bounds.width-32, height: 200)
                    .padding(.vertical, 8)
                    .cornerRadius(20)
                    .overlay {
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(Color.customBlack, lineWidth: 1)
                    }
                    .padding(.top, 8)
                    Spacer()
                    CallBottomBar(isMuted: viewModel.isMuted, isMutedAction: {
                        viewModel.muteAudio()
                    }, isSpeaker: viewModel.isSpeaker) {
                        viewModel.changeOutputRouter()
                    } leaveAction: {
                        viewModel.alertType = .leaveWarning
                        viewModel.isAlert = true
                    }
                }
                .padding(.top, 16)
            }
        }
        .navigationBarBackButtonHidden()
        .onAppear {
            if appState.isHostCallReload {
                viewModel.createOneToOneChannel(
                    chatRoomId: self.chatRoomId,
                    fromUser: fromUser,
                    toUser: toUser
                )
                appState.isHostCallReload = false
            }
        }
        .alert(isPresented: $viewModel.isAlert){
            switch viewModel.alertType {
            case .connectionFatalWarning:
                return Alert(
                    title: Text("通話エラー"),
                    message: Text("すでに終了された通話です。"),
                    dismissButton: .default(Text("戻る"), action: {
                        appState.isHostCallReload = true
                        dismiss()
                    })
                )
            case .leaveWarning:
                return Alert(
                    title: Text("終了"),
                    message: Text("通話を終了します。よろしいですか？"),
                    primaryButton: .default(
                        Text("終了する"), action: {
                            viewModel.stopChannel(
                                userId:  fromUser.user.uid,
                                chatRoomId: self.chatRoomId
                            )
                            appState.isHostCallReload = true
                        }),
                    secondaryButton: .default(Text("キャンセル")))
            }
        }
        .onReceive(viewModel.$isSuccessCallLeave){
            if $0 {
                dismiss()
            }
        }
    }
}

struct CallGuideLine: Identifiable {
    let id = UUID()
    var text: String
    var description: String
}


var callGuideLines:[CallGuideLine] = [.init(text: "尊重のある言葉遣い", description: "卑猥な言葉や暴言は厳禁です。"), .init(text: "プライバシーの尊重", description: "個人情報の共有は控えましょう。"), .init(text: "コミュニケーションの範疇", description: "営利目的の宣伝やスパムは禁止です。")]
