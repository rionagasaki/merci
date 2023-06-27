//
//  FilterlingFriendCellView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/06/27.
//

import SwiftUI
import SDWebImageSwiftUI

struct FilterlingFriendView: View {
    @EnvironmentObject var userModel: UserObservableModel
    let viewModel: GoodsListViewModel
    @Binding var pair: PairObservableModel?
    var body: some View {
        
        ForEach(viewModel.friendList){ friend in
            Button {
                guard let pairID = userModel.pairList[friend.uid] else { return }
                FetchFromFirestore().fetchPairInfo(pairID: pairID) { pair in
                    self.pair = .init(pairModel: pair.adaptPairModel())
                    viewModel.selectedPairChatRoomIDs = pair.chatPairIDs
                    viewModel.fetch()
                }
            } label: {
                HStack {
                    WebImage(url: URL(string: friend.profileImageURL))
                        .resizable()
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                    Text(friend.nickname)
                        .foregroundColor(.customBlack)
                        .font(.system(size: 22, weight: .bold))
                    Spacer()
                }
            }
            .padding(.horizontal, 8)

        }
    }
}
