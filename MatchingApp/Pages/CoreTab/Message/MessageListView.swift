//
//  SendGoodsListView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/06/02.
//

import SwiftUI
import SDWebImageSwiftUI

struct MessageListView: View {
    @State var selection: Int = 0
    @StateObject var viewModel = MessageListViewModel()
    @EnvironmentObject var userModel: UserObservableModel
    @EnvironmentObject var appState: AppState
    let UIIFGeneratorMedium = UIImpactFeedbackGenerator(style: .heavy)
    
    var body: some View {
        List {
            if viewModel.onlineUsers.count != 0 {
                Section {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack {
                            ForEach(viewModel.onlineUsers) { user in
                                NavigationLink {
                                    UserProfileView(userId: user.user.uid, isFromHome: false)
                                } label: {
                                    OnlineUser(user: user)
                                }
                            }
                        }
                    }
                } header: {
                    Text("👀オンライン中の動物")
                        .foregroundColor(.customBlack)
                        .font(.system(size: 16, weight: .medium))
                }
            }
            
            Section {
                if viewModel.allChatmateUsers.count == 0 {
                    HStack {
                        Spacer()
                        Image("Ice")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 96, height: 96)
                        Text("表示できるメッセージがありません")
                            .foregroundColor(.customBlack)
                            .font(.system(size: 18, weight: .bold))
                        Spacer()
                    }
                } else {
                    ForEach(viewModel.chatmateUsers.count == 0 ? viewModel.allChatmateUsers :viewModel.chatmateUsers) { user in
                        NavigationLink {
                            ChatView(toUser: user)
                        } label: {
                            MessageListCellView(chatmate: user)
                        }
                        .swipeActions(edge: .trailing) {
                            Button {
                                viewModel.setChatRoomHidden(fromUserID: userModel.user.uid, toUserID: user.user.uid)
                            } label: {
                                Text("非表示")
                            }
                            .tint(Color.customRed)
                        }
                    }
                }
            } header: {
                Text("💬チャットリスト")
                    .foregroundColor(.customBlack)
                    .font(.system(size: 16, weight: .medium))
            }

        }
        .scrollContentBackground(.hidden)
        .background(Color.customLightGray)
        .navigationBarTitleDisplayMode(.inline)
        .sheet(isPresented: $viewModel.isSelectChatPairHalfModal){
            FilterlingChatmateView(
                user: userModel,
                allChatmateUsers: viewModel.allChatmateUsers,
                chatmateUsers: $viewModel.chatmateUsers,
                chatmateKind: $viewModel.chatmateKind
            )
            .presentationDetents([.height(150)])
        }
        .onAppear {
            Task {
                viewModel.chatmateUsers = []
                await viewModel.getChatmateInfoAndOnlineUser(chatmateUsersMapping: userModel.user.chatmateMapping, userModel: userModel)
            }
        }
        .alert(isPresented: $viewModel.isErrorAlert){
            Alert(title: Text("エラー"), message: Text(viewModel.errorMessage))
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing){
                Button {
                    viewModel.isSelectChatPairHalfModal = true
                } label: {
                    Image(systemName: "line.3.horizontal.decrease")
                }
                .foregroundColor(.black)
            }
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                VStack(spacing: 2){
                    Text("メッセージ・通話")
                        .foregroundColor(.customBlack)
                        .font(.system(size: 24, weight: .bold))
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(.customBlue.opacity(0.5))
                        .frame(height: 3)
                }
            }
        }
        .refreshable {
            Task {
                UIIFGeneratorMedium.impactOccurred()
                await viewModel.getChatmateInfoAndOnlineUser(chatmateUsersMapping: userModel.user.chatmateMapping, userModel: userModel)
            }
        }
    }
}

struct MessageListView_Previews: PreviewProvider {
    static var previews: some View {
        MessageListView()
    }
}
