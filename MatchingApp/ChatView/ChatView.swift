//
//  ChatView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/01.
//

import SwiftUI
import SDWebImageSwiftUI

struct ChatView: View {
    @StateObject private var viewModel = ChatViewModel()
    @FocusState var focus: Bool
    let pair: PairObservableModel
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var pairModel: PairObservableModel
    @EnvironmentObject var userModel: UserObservableModel
    @Environment(\.dismiss) var dismiss
    @State var chatRoomID = ""
    @State var alert: Bool = false
    @State var profileModalFlag: Bool = false
    @State var id: UUID = UUID()
    
    var body: some View {
        VStack{
            ScrollView(.horizontal){
                HStack {
                    ForEach([pair.pair.pair_1_profileImageURL, pair.pair.pair_2_profileImageURL, pairModel.pair.pair_1_profileImageURL, pairModel.pair.pair_2_profileImageURL], id: \.self) { image in
                        WebImage(url: URL(string: image))
                            .resizable()
                            .frame(width: 25, height:25)
                            .clipShape(Circle())
                    }
                    Spacer()
                }
                .padding(.leading, 16)
                .padding(.top, 8)
            }
            ScrollViewReader { reader in
                ScrollView {
                    VStack {
                        ForEach(viewModel.chatList){ messageInfo in
                            if messageInfo.sendUserID == userModel.uid {
                                MyMessageBubbleView(messageInfo: messageInfo)
                                    .onAppear {
                                        id = messageInfo.id
                                    }
                                    .id(messageInfo.id)
                            } else {
                                OtherUserMessageBubbleView(messageInfo: messageInfo)
                                    .onAppear {
                                        id = messageInfo.id
                                    }
                                    .id(messageInfo.id)
                            }
                        }
                    }
                }
                .onChange(of: id) { id in
                    withAnimation {
                        reader.scrollTo(id)
                    }
                }
                .onAppear {
                    withAnimation {
                        reader.scrollTo(id)
                    }
                }
                
                Spacer()
                Group {
                    Divider()
                    HStack {
                        TextField(text: $viewModel.text) {
                            Text("")
                        }
                        .padding(.leading, 16)
                        .background{
                            RoundedRectangle(cornerRadius: 5)
                                .frame(height: 40)
                                .foregroundColor(.gray.opacity(0.1))
                        }
                        .focused(self.$focus)
                        Button {
                            if viewModel.text == "" {
                                alert = true
                                return
                            }
                            if chatRoomID == "" {
                                SetToFirestore.shared.makeChat(
                                    requestPairID: pairModel.pair.id,
                                    requestedPairID: pair.pair.id,
                                    message: viewModel.text,
                                    sendUserInfo: userModel,
                                    currentPairUserID: appState.pairUserModel.uid,
                                    currentChatPairUserID_1: pair.pair.pair_1_uid,
                                    currentChatPairUserID_2: pair.pair.pair_2_uid,
                                    recieveNotificatonTokens: [pair.pair.pair_2_fcmToken, pair.pair.pair_1_fmcToken, appState.pairUserModel.fcmToken],
                                    createdAt: Date()
                                ){ chatRoomID in
                                    self.chatRoomID = chatRoomID
                                    FetchFromFirestore()
                                        .snapshotOnChat(chatroomID: chatRoomID) { chat in
                                            viewModel.chatList.append(.init(
                                                message: chat.message,
                                                createdAt: DateFormat.shared.timeFormat(date: chat.createdAt.dateValue()),
                                                sendUserID: chat.sendUserID,
                                                sendUserNickname: chat.sendUserNickname,
                                                sendUserProfileImageURL: chat.sendUserProfileImageURL
                                            ))
                                        }
                                }
                            } else {
                                SetToFirestore.shared.sendMessage(
                                    chatRoomID: chatRoomID,
                                    currentUserPairID: pairModel.pair.id,
                                    chatPairID: pair.pair.id,
                                    currentPairUserID: appState.pairUserModel.uid,
                                    currentChatPairUserID_1: pair.pair.pair_1_uid,
                                    currentChatPairUserID_2: pair.pair.pair_2_uid,
                                    createdAt: Date(),
                                    message: viewModel.text,
                                    user: userModel,
                                    recieveNotificatonTokens: [
                                        appState.pairUserModel.fcmToken,
                                        pair.pair.pair_1_fmcToken,
                                        pair.pair.pair_2_fcmToken
                                    ]
                                )
                            }
                            viewModel.text = ""
                        } label: {
                            Text("送信")
                                .foregroundColor(.white)
                                .padding(.horizontal, 16)
                                .frame(height: 40)
                                .background(Color.blue.opacity(0.8))
                                .cornerRadius(5)
                            
                        }
                        .task(id: viewModel.trigger) {
                            guard viewModel.trigger != nil else { return }
                            await viewModel.tappedSendButton()
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.bottom, 8)
                    .padding(.top, 8)
                }
            }
            .padding(.top, 16)
        }
        .navigationBarBackButtonHidden()
        .navigationTitle("\(pair.pair.pair_1_nickname)&\(pair.pair.pair_2_nickname)")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    profileModalFlag = true
                } label: {
                    VStack {
                        Image(systemName: "doc.plaintext")
                        Text("プロフ確認")
                            .font(.system(size: 10,weight: .light))
                    }
                    .foregroundColor(.black)
                }
            }
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("メッセージ")
                    }
                    .foregroundColor(.black)
                }
            }
        }
        .sheet(isPresented: $profileModalFlag){
            ModalGroupProfileView(pair: pair)
        }
        .onTapGesture {
            print(pair.id)
            self.focus = false
        }
        .onAppear {
            viewModel.chatList = []
            if let chatRoomID = pairModel.pair.chatPairIDs[pair.pair.id] {
                userModel.chatUnreadNum[chatRoomID] = 0
                self.chatRoomID = chatRoomID
                FetchFromFirestore()
                    .snapshotOnChat(chatroomID: chatRoomID) { chat in
                        viewModel.chatList.append(.init(
                            message: chat.message,
                            createdAt: DateFormat.shared.timeFormat(date: chat.createdAt.dateValue()),
                            sendUserID: chat.sendUserID,
                            sendUserNickname: chat.sendUserNickname,
                            sendUserProfileImageURL: chat.sendUserProfileImageURL
                        ))
                    }
            } else {
                self.chatRoomID = ""
                print("No chat room")
            }
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(pair: .init(pairModel: .init()), id: UUID())
    }
}
