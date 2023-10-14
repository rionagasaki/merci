//
//  HiddenChatUsersListView.swift
//  Merci
//
//  Created by Rio Nagasaki on 2023/09/22.
//
import SwiftUI

struct HiddenChatUserListView: View {
    @StateObject var viewModel = HiddenChatUserListViewModel()
    @EnvironmentObject var userModel: UserObservableModel
    private let UIIFGeneratorMedium = UIImpactFeedbackGenerator(style: .heavy)
    var body: some View {
        VStack {
            Text("相手から新規メッセージが届くか、\n左スワイプにより解除すると再表示されます。")
                .foregroundColor(.customBlack)
                .font(.system(size: 16, weight: .medium))
                .padding(.horizontal, 16)
                .padding(.top, 24)
            if viewModel.hiddenChatUsers.count == 0 {
                ScrollView {
                    Image("Block")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 96, height: 96)
                        .padding(.top, 80)
                    Text("非表示中のユーザーはいません")
                        .foregroundColor(.customBlack)
                        .font(.system(size: 18, weight: .medium))
                }
                .refreshable {
                    Task {
                        UIIFGeneratorMedium.impactOccurred()
                        await self.viewModel.initial(userModel: userModel)
                    }
                }
            } else {
                List {
                    ForEach(viewModel.hiddenChatUsers){ user in
                        UserListCellView(user: user)
                        .swipeActions {
                            Button {
                                viewModel.resolveHiddenChatRoom(fromUserModel: userModel, toUserID: user.user.uid)
                            } label: {
                                Text("再表示")
                            }
                            .tint(Color.customRed)
                        }
                    }
                }
                .listStyle(.plain)
                .refreshable {
                    Task {
                        await self.viewModel.initial(userModel: userModel)
                    }
                }
            }
        }
        .onAppear {
            Task {
                await viewModel.initial(userModel: userModel)
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal){
                Text("非表示中のユーザー")
                    .foregroundColor(.customBlack)
                    .font(.system(size: 16, weight: .medium))
            }
        }
    }
}
