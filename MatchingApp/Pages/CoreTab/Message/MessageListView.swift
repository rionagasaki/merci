//
//  SendGoodsListView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/06/02.
//

import SwiftUI
import SDWebImageSwiftUI
import PartialSheet

struct MessageListView: View {
    @State var selection: Int = 0
    @StateObject var viewModel = MessageListViewModel()
    @EnvironmentObject var userModel: UserObservableModel
    @EnvironmentObject var appState: AppState
    let UIIFGeneratorMedium = UIImpactFeedbackGenerator(style: .heavy)
    
    var body: some View {
        VStack {
            if viewModel.allChatmateUsers.count == 0 {
                ScrollView {
                    VStack {
                        Spacer()
                        Image("Ice")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 96, height: 96)
                        Text("表示できるメッセージがありません")
                            .foregroundColor(.customBlack)
                            .font(.system(size: 18, weight: .bold))
                    }
                    .padding(.top, 128)
                }
                .refreshable {
                    UIIFGeneratorMedium.impactOccurred()
                    viewModel.fetchChatmateInfo(chatmateUsersMapping: userModel.user.chatmateMapping, userModel: userModel)
                }
            } else {
                List {
                    ForEach(viewModel.chatmateUsers.count == 0 ? viewModel.allChatmateUsers :viewModel.chatmateUsers) { user in
                        NavigationLink {
                            ChatView(user: user)
                        } label: {
                            MessageListCellView(chatmate: user)
                        }
                    }
                }
                .padding(.top, 8)
                .listStyle(.plain)
                .refreshable {
                    UIIFGeneratorMedium.impactOccurred()
                    viewModel.fetchChatmateInfo(chatmateUsersMapping: userModel.user.chatmateMapping, userModel: userModel)
                }
            }
        }
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
            viewModel.chatmateUsers = []
            viewModel.fetchChatmateInfo(chatmateUsersMapping: userModel.user.chatmateMapping, userModel: userModel)
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
    }
}

struct MessageListView_Previews: PreviewProvider {
    static var previews: some View {
        MessageListView()
    }
}
