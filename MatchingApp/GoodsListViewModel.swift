//
//  GoodsListViewModel.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/06/03.
//

import Foundation

class GoodsListViewModel: ObservableObject {
    @Published var matchingPairIDs: [String: Any] = [:]
    @Published var messageList: [PairObservableModel] = []
    
    func fetch(){
        var pairKeys:[String] = []
        matchingPairIDs.forEach { data in
            pairKeys.append(data.key)
        }
        FetchFromFirestore().fetchConcurrentPairInfo(pairIDs: pairKeys) { pairs in
            pairs.forEach { pair in
                self.messageList.append(.init(
                    id: pair.id,
                    gender: pair.gender,
                    pair_1_uid: pair.pair_1_uid,
                    pair_1_nickname: pair.pair_1_nickname,
                    pair_1_profileImageURL: pair.pair_1_profileImageURL,
                    pair_1_activeRegion: pair.pair_1_activeRegion,
                    pair_1_birthDate: pair.pair_1_birthDate,
                    pair_2_uid: pair.pair_2_uid,
                    pair_2_nickname: pair.pair_2_nickname,
                    pair_2_profileImageURL: pair.pair_2_profileImageURL,
                    pair_2_activeRegion: pair.pair_2_activeRegion,
                    pair_2_birthDate: pair.pair_2_birthDate
                ))
            }
        }
    }
}
