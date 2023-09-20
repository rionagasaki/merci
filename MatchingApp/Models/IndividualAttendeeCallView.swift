//
//  IndividualAttendeeCallView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/08/30.
//

import SwiftUI
import SDWebImageSwiftUI

struct IndividualAttendeeCallView: View {
    let channelId: String
    let chatRoomId: String
    let messageId: String
    
    @StateObject var viewModel = IndividualAttendeeCallViewModel()
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var userModel: UserObservableModel
    
    var body: some View {
        ZStack {
            if viewModel.isLoading {
                VStack {
                    Text(userModel.user.nickname)
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .medium))
                    LottieView(animationResourceName: "calling", loopMode: .loop, isActive: true)
                        .frame(width: 120, height: 120)
                    Text("通話ルームを作成しています。少々お待ちください。")
                        .foregroundColor(.white)
                        .font(.system(size: 14))
                        .padding(.top, 24)
                }
            } else {
                VStack {
                    Image(userModel.user.profileImageURLString)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 96, height: 96)
                        .padding(.all, 16)
                        .background(Color.gray.opacity(0.1))
                        .clipShape(Circle())
                        .overlay {
                            Circle()
                                .stroke(.white, lineWidth: 2)
                        }
                    
                    Text(userModel.user.nickname)
                        .foregroundColor(.white)
                        .font(.system(size: 24, weight: .medium))
                    
                    VStack(alignment: .leading){
                        Label {
                            Text("通話のルール")
                                .foregroundColor(.white)
                                .font(.system(size: 24, weight: .medium))
                        } icon: {
                            Image(systemName: "exclamationmark.bubble.fill")
                                .resizable()
                                .scaledToFill()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.yellow)
                        }
                        .padding(.top, 8)

                        ForEach(callGuideLines) { guideline in
                            VStack(alignment: .leading){
                                Text(guideline.text)
                                    
                                Text(guideline.description)
                            }
                            .foregroundColor(.customBlack)
                        }
                        Spacer()
                    }
                    .frame(
                        width: UIScreen.main.bounds.width-32
                    )
                    .padding(.vertical, 8)
                    .cornerRadius(20)
                    .overlay {
                        RoundedRectangle(cornerRadius: 20)
                            .stroke(.white, lineWidth: 2)
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
            if appState.isAttendeeCallReload {
                viewModel.joinCall(
                    channelId: channelId,
                    chatRoomID: chatRoomId,
                    userModel: userModel
                )
                appState.isAttendeeCallReload = false
            }
        }
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
            case .leaveWarning:
                return Alert(
                    title: Text("終了"),
                    message: Text("通話を終了します。よろしいですか？"),
                    primaryButton: .default(
                        Text("終了する"), action: {
                            viewModel.stopChannel(
                                userId: userModel.user.uid,
                                chatRoomId: self.chatRoomId,
                                channelId: self.channelId
                                )
                            appState.isAttendeeCallReload = true
                        }),
                    secondaryButton: .default(Text("キャンセル")))
            }
        }
        .onReceive(viewModel.$isSuccessCallLeave) {
            if $0 {
                dismiss()
                appState.isAttendeeCallReload = true
            }
        }
    }
}
