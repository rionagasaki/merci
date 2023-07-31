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
    
    var body: some View {
        VStack{
            ScrollView(.horizontal){
                HStack {
                    ForEach([
                        pair.pair.pair_1_profileImageURL,
                        pair.pair.pair_2_profileImageURL,
                        pairModel.pair.pair_1_profileImageURL,
                        pairModel.pair.pair_2_profileImageURL
                    ], id: \.self) { image in
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
                            if messageInfo.sendUserID == userModel.user.uid {
                                MyMessageBubbleView(messageInfo: messageInfo)
                                   
                                   
                            } else {
                                OtherUserMessageBubbleView(messageInfo: messageInfo)
    
                        
                            }
                        }
                    }
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
                }
                Spacer()
                Group {
                    Divider()
                    HStack {
                        TextField(text: $viewModel.messageText) {
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
                            if viewModel.chatRoomId.isEmpty {
                                viewModel.makeChatRoomAndSendMessage(
                                    userModel: userModel,
                                    pairModel: pairModel,
                                    chatPair: pair,
                                    appState: appState
                                )
                            } else {
                                viewModel.sendMessage(
                                    userModel: userModel,
                                    pairModel: pairModel,
                                    chatPair: pair,
                                    appState: appState
                                )
                            }
                        } label: {
                            Text("送信")
                                .foregroundColor(.white)
                                .padding(.horizontal, 16)
                                .frame(height: 40)
                                .background(Color.blue.opacity(0.8))
                                .cornerRadius(5)
                            
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
                    viewModel.isPairProfileModal = true
                } label: {
                    VStack {
                        Image(systemName: "doc.plaintext")
                        Text("プロフ確認")
                            .font(.system(size: 10,weight: .light))
                    }
                    .foregroundColor(.customBlack)
                }
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    self.viewModel.isJoinCallModal = true
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
        .fullScreenCover(isPresented: $viewModel.isJoinCallModal, content: {
            CallView()
        })
        .sheet(isPresented: $viewModel.isPairProfileModal){
            ModalGroupProfileView(pair: pair)
        }
        .alert(isPresented: $viewModel.isErrorAlert){
            Alert(title: Text("エラー"), message: Text(viewModel.errorMessage))
        }
        .onTapGesture {
            self.focus = false
        }
        .onAppear {
            viewModel.chatList = []
            if let chatRoomID = pairModel.pair.chatPairIDs[pair.pair.id] {
                userModel.user.unreadMessageCount[chatRoomID] = 0
                self.viewModel.chatRoomId = chatRoomID
                viewModel.fetchMessage()
            }
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView(pair: .init(pairModel: .init()))
    }
}
