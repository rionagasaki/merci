//
//  ChatView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/01.
//

import SwiftUI

struct ChatView: View {
    let user: UserObservableModel
    private let requestMicrophone = RequestMicrophone()
    @EnvironmentObject var userModel: UserObservableModel
    @EnvironmentObject var appState: AppState
    @StateObject private var viewModel = ChatViewModel()
    @FocusState var focus: Bool
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                if !viewModel.channelId.isEmpty {
                    HStack(alignment: .top){
                        ZStack(alignment: .bottomTrailing){
                            Image(user.user.profileImageURLString)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 64, height: 64)
                                .background(Color.gray.opacity(0.1))
                                .clipShape(Circle())
                            
                            Image(systemName: "phone.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width:24, height:24)
                                .foregroundColor(.green)
                                .background(Color.white)
                                .clipShape(Circle())
                        }
                        Spacer()
                        VStack(alignment: .trailing){
                            Text("\(user.user.nickname)さんはもうそこにいます！")
                                .foregroundColor(.customBlack)
                                .font(.system(size: 14, weight: .medium))
                            
                            Button {
                                viewModel.isJoinCall = true
                            } label: {
                                Text("通話に参加する")
                                    .foregroundColor(.white)
                                    .font(.system(size: 12, weight: .medium))
                                    .padding(.all, 8)
                                    .background(Color.green)
                                    .cornerRadius(10)
                            }
                        }
                    }
                    .padding(.vertical, 8)
                    .padding(.horizontal, 24)
                    .background(Color.customBlue.opacity(0.5))
                }
                ScrollViewReader { reader in
                    VStack {
                        VStack {
                            ScrollView {
                                VStack {
                                    ForEach(viewModel.allMessages){ message in
                                        if message.fromUserUid == userModel.user.uid {
                                            MyMessageBubbleView(message: message)
                                                .id(UUID.init(uuidString: message.chatId))
                                        } else {
                                            OtherUserMessageBubbleView(message: message, user: user)
                                                .id(UUID.init(uuidString: message.chatId))
                                        }
                                    }
                                }
                                .padding(.top, 16)
                            }
                            
                            .onChange(of: viewModel.scrollId) { id in
                                withAnimation {
                                    reader.scrollTo(viewModel.scrollId)
                                }
                            }
                            .onAppear {
                                withAnimation {
                                    reader.scrollTo(viewModel.scrollId)
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                                    withAnimation {
                                        viewModel.requestedCallNoticeOffSet = 0
                                    }
                                }
                            }
                            Group {
                                Divider()
                                HStack(alignment: .bottom){
                                    TextEditor(text: $viewModel.messageText)
                                        .scrollContentBackground(Visibility.hidden)
                                        .frame(height: viewModel.textFieldHeight)
                                        .background{
                                            RoundedRectangle(cornerRadius: 5)
                                                .frame(height: viewModel.textFieldHeight)
                                                .foregroundColor(.gray.opacity(0.1))
                                        }
                                        .onChange(of: viewModel.messageText) { newValue in
                                            if newValue.filter({ $0 == "\n" }).count > viewModel.newlineCount {
                                                if viewModel.textFieldHeight < 40 + 16*4 {
                                                    viewModel.textFieldHeight += 16
                                                }
                                            } else if newValue.filter({ $0 == "\n" }).count < viewModel.newlineCount  {
                                                if viewModel.textFieldHeight > 40 {
                                                    viewModel.textFieldHeight -= 16
                                                }
                                            } else {}
                                            viewModel.newlineCount = newValue.filter { $0 == "\n" }.count
                                        }
                                        .onTapGesture {
                                            DispatchQueue.main.asyncAfter(deadline: .now()+0.3) {
                                                withAnimation {
                                                    reader.scrollTo(viewModel.scrollId)
                                                }
                                            }
                                        }
                                        .focused(self.$focus)
                                    
                                    Button {
                                        if viewModel.chatRoomId.isEmpty {
                                            viewModel.createChatRoomAndSendMessage(
                                                fromUser: userModel,
                                                toUser: user,
                                                appState: appState
                                            )
                                        } else {
                                            viewModel.sendMessage(
                                                fromUser: userModel,
                                                toUser: user,
                                                appState: appState
                                            )
                                        }
                                    } label: {
                                        Text("送信")
                                            .foregroundColor(.white)
                                            .padding(.horizontal, 16)
                                            .frame(height: 40)
                                            .background(Color.customBlue)
                                            .cornerRadius(5)
                                    }
                                }
                                .padding(.horizontal, 16)
                                .padding(.bottom, 8)
                            }
                        }
                    }
                }
                .padding(.top, 16)
            }
            .ignoresSafeArea(.keyboard, edges: .bottom)
            .navigationBarBackButtonHidden()
            .navigationTitle("\(user.user.nickname)")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        if !userModel.user.friendUids.contains(user.user.uid) {
                            self.viewModel.isRequiredAddFriend = true
                        } else {
                            self.viewModel.isCreateCallActionSheet = true
                        }
                    } label: {
                        VStack {
                            Image(systemName: "phone")
                            Text("通話")
                                .font(.system(size: 10,weight: .light))
                        }
                        .foregroundColor(.customBlack)
                    }
                    
                }
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        self.focus = false
                        viewModel.updateMessageUnReadCountZero(user: userModel)
                        DispatchQueue.main.asyncAfter(deadline: .now()+0.4) {
                            dismiss()
                        }
                        
                    } label: {
                        HStack {
                            Image(systemName: "chevron.left")
                            Text("メッセージ")
                        }
                        .foregroundColor(.black)
                    }
                }
            }
            .actionSheet(isPresented: $viewModel.isCreateCallActionSheet){
                ActionSheet(
                    title: Text("📞発信"),
                    message: Text("\(user.user.nickname)さんへ発信します。"),
                    buttons: [
                        .default(Text("発信"), action: {
                            if !userModel.user.isCallingChannelId.isEmpty {
                                viewModel.errorMessage = "現在、他の通話に参加中です。"
                                viewModel.isErrorAlert = true
                            }
                            else if !user.user.isCallingChannelId.isEmpty {
                                viewModel.errorMessage = "相手のユーザーが通話中です。"
                                viewModel.isErrorAlert = true
                            } else {
                                viewModel.isCreateCall = true
                            }
                        }),
                        .cancel()
                    ]
                )
            }
            .alert(isPresented: $viewModel.isErrorAlert){
                Alert(title: Text("エラー"), message: Text(viewModel.errorMessage))
            }
            .alert(isPresented: $viewModel.isRequiredAddFriend, content: {
                Alert(title: Text("友達になろう"), message: Text("通話をするには、\(user.user.nickname)さんと友達になる必要があります。"))
            })
            .onTapGesture {
                self.focus = false
            }
            .navigationDestination(isPresented: $viewModel.isCreateCall) {
                IndividualHostCallView(
                    chatRoomId: viewModel.chatRoomId,
                    messageId: viewModel.messageId,
                    fromUser: userModel,
                    toUser: user
                )
            }
            .navigationDestination(isPresented: $viewModel.isJoinCall){
                IndividualAttendeeCallView(
                    channelId: viewModel.channelId,
                    chatRoomId: viewModel.chatRoomId,
                    messageId: viewModel.messageId
                )
            }
            .onAppear {
                viewModel.allMessages = []
                if let chatRoomId = userModel.user.chatmateMapping[user.user.uid] {
                    self.viewModel.chatRoomId = chatRoomId
                    viewModel.initial(user: userModel, chatRoomId: chatRoomId)
                    viewModel.initialChatRoom(chatRoomId: chatRoomId)
                }
            }
            .onDisappear {
                viewModel.updateMessageUnReadCountZero(user: userModel)
            }
        }
    }
}
