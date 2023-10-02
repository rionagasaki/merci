//
//  BlockedUserListView.swift
//  Merci
//
//  Created by Rio Nagasaki on 2023/09/22.
//

import SwiftUI

struct BlockedUserListView: View {
    @StateObject var viewModel = BlockedUserListViewModel()
    @EnvironmentObject var userModel: UserObservableModel
    var body: some View {
        VStack {
            if viewModel.blockedUser.count == 0 {
                ScrollView {
                    Image("Block")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 96, height: 96)
                    Text("ブロック中のユーザーはいません")
                        .foregroundColor(.customBlack)
                        .font(.system(size: 18, weight: .bold))
                }
                .refreshable {
                    viewModel.initial(userModel: userModel)
                }
            } else {
                List {
                    ForEach(viewModel.blockedUser){ user in
                        UserListCellView(user: user)
                            .swipeActions {
                                Button {
                                    viewModel.resolveBlock(userModel: userModel, user: user)
                                } label: {
                                    Text("解除")
                                }
                                .tint(.yellow)
                            }
                    }
                }
                .listStyle(.plain)
                .refreshable {
                    viewModel.initial(userModel: userModel)
                }
            }
        }
        .onAppear {
            viewModel.initial(userModel: userModel)
        }
        .toolbar {
            ToolbarItem(placement: .principal){
                Text("ブロックしたユーザー")
                    .foregroundColor(.customBlack)
                    .font(.system(size: 16, weight: .medium))
            }
        }
    }
}

struct BlockedUserListView_Previews: PreviewProvider {
    static var previews: some View {
        BlockedUserListView()
    }
}
