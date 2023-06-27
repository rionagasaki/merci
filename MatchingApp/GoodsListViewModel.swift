//
//  GoodsListViewModel.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/06/03.
//

import Foundation

class GoodsListViewModel: ObservableObject {
    @Published var selectedPairChatRoomIDs: [String: String] = [:]
     
    @Published var messageList: [PairObservableModel] = []
    @Published var friendList: [UserObservableModel] = []
    @Published var selectedPairMessageList:[PairObservableModel] = []
    
    
    func fetch(){
        messageList = []
        var pairKeys:[String] = []
        selectedPairChatRoomIDs.forEach { data in
            pairKeys.append(data.key)
        }
        FetchFromFirestore().fetchConcurrentPairInfo(pairIDs: pairKeys) { pairs in
            pairs.forEach { pair in
                
                self.messageList.append(.init(
                    pairModel: pair.adaptPairModel()
                ))
            }
        }
    }
    
    func fetchFriend(friendUids: [String]){
        FetchFromFirestore().fetchConcurrentUserInfo(userIDs: friendUids) { users in
            users.forEach { user in
                self.friendList.append(user.adaptUserObservableModel())
            }
        }
    }
}
