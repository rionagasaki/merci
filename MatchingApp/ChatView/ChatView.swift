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
    @EnvironmentObject var pairModel: PairObservableModel
    @EnvironmentObject var userModel: UserObservableModel
    @Environment(\.dismiss) var dismiss
    @State var chatRoomID = ""
    @State var alert: Bool = false
    @State var profileModalFlag: Bool = false
    
    var body: some View {
        VStack {
            ScrollView {
                VStack {
                    ForEach(viewModel.chatList){ messageInfo in
                        if messageInfo.sendUserID == userModel.uid {
                            MyMessageBubbleView(messageInfo: messageInfo)
                        } else {
                            OtherUserMessageBubbleView(messageInfo: messageInfo)
                        }
                    }
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
                        //　すでにチャットをしている。
                        if chatRoomID == "" {
                            SetToFirestore.shared.makeChat(requestPairID: pairModel.id, requestedPairID: pair.id, message: viewModel.text, sendUserID: userModel.uid)
                        } else {
                            SetToFirestore.shared.sendMessage(
                                chatRoomID: chatRoomID,
                                sendUserID: userModel.uid,
                                sendUserNickname: userModel.nickname,
                                sendUserProfileImageURL: userModel.profileImageURL,
                                createdAt: Date(),
                                message: viewModel.text
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
        .padding(.top, 32)
        .navigationBarBackButtonHidden()
        .navigationTitle("\(pair.pair_1_nickname)&\(pair.pair_2_nickname)")
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
            chatRoomID = ""
            pairModel.chatPairIDs.forEach { data in
                    chatRoomID = data.value as! String
                print(chatRoomID)
            }
            
            if chatRoomID != "" {
                FetchFromFirestore().snapshotOnChat(chatroomID: chatRoomID) { chat in
                    viewModel.chatList.append(.init(
                        message: chat.message,
                        createdAt: DateFormat.shared.timeFormat(date: chat.createdAt.dateValue()),
                        sendUserID: chat.sendUserID,
                        sendUserNickname: chat.sendUserNickname,
                        sendUserProfileImageURL: chat.sendUserProfileImageURL
                    ))
                }
            }
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(pair: .init())
    }
}
