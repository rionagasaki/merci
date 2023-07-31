//
//  GoodsListViewModel.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/06/03.
//

import Foundation
import Combine

class MessageListViewModel: ObservableObject {
    @Published var chatPartnerUser: [UserObservableModel] = []
    @Published var selectedChatPartnerUid: String = ""
    @Published var selectedChatPartnerMessageList:[PairObservableModel] = []
    @Published var isSelectChatPairHalfModal: Bool = false
    @Published var isSelectedSuccess: Bool = false
    @Published var isErrorAlert: Bool = false
    @Published var errorMessage: String = ""
    let fetchFromFirestore = FetchFromFirestore()
    var cancellable = Set<AnyCancellable>()
    
    func fetchChatPartnerInfo(chatPartnerUsersMapping: [String: String]){
        let chatPartnerUids:[String] = Array<String>(chatPartnerUsersMapping.keys)
        fetchFromFirestore.fetchConcurrentUserInfo(userIDs: chatPartnerUids)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("message reload success")
                case .failure(let error):
                    self.isErrorAlert = true
                    self.errorMessage = error.errorMessage
                }
            }, receiveValue: { chatPartnerUser in
                self.chatPartnerUser = chatPartnerUser.map { .init( userModel: $0.adaptUserObservableModel() )}
            })
            .store(in: &self.cancellable)
    }
    
    func changePairAndFetchMessageRooms(userModel: UserObservableModel, selectedChatPartnerUid: String){
        guard let selectedPairID = userModel.user.pairMapping[selectedChatPartnerUid] else { return }
        fetchFromFirestore.fetchPairInfo(pairID: selectedPairID)
            .flatMap { pair in
                let selectedUserChatPairIDs: [String] = Array(pair.chatPairIDs.keys)
                return self.fetchFromFirestore.fetchConcurrentPairInfo(pairIDs: selectedUserChatPairIDs)
            }
            .sink { completion in
                switch completion {
                case .finished:
                    self.isSelectedSuccess = true
                case .failure(let error):
                    self.isErrorAlert = true
                    self.errorMessage = error.errorMessage
                }
            } receiveValue: { pairInfos in
                self.selectedChatPartnerMessageList = []
                self.selectedChatPartnerMessageList = self.convertPairArrayToObservable(pairArray: pairInfos)
            }
            .store(in: &self.cancellable)
    }
    
    func convertPairArrayToObservable(pairArray: [Pair]) -> [PairObservableModel] {
        return pairArray.map { pair in
            let pairModel = pair.adaptPairModel()
            return PairObservableModel(pairModel: pairModel)
        }
    }
}
