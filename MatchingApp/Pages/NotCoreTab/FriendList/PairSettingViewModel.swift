//
//  FriendListViewModel.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/07/04.
//

import Foundation
import Combine
import SwiftUI

class PairSettingViewModel: ObservableObject {
    @Published var currentPairUser: UserObservableModel?
    @Published var pastPairUsers: [UserObservableModel] = []
    @Published var requestedPairUsers: [UserObservableModel] = []
    @Published var requestPairUser: UserObservableModel?
    @Published var searchResultUser: UserObservableModel?
    @Published var searchQuery: String = ""
    @Published var submit: Bool = false
    @Published var unPairRequestModal: Bool = false
    @Published var isErrorAlert: Bool = false
    @Published var errorMessage: String = ""
    
    let fetchFromFirestore = FetchFromFirestore()
    let setToFirestore = SetToFirestore()
    let UIIFGeneratorMedium = UIImpactFeedbackGenerator(style: .medium)
    private var cancellable = Set<AnyCancellable>()
    
    func initialFriendList(userModel: UserObservableModel){
        fetchFromFirestore.fetchUserInfoFromFirestoreByUserID(uid: userModel.user.pairRequestUid)
            .flatMap { user -> AnyPublisher<[User], AppError> in
                if let user = user {
                    self.requestPairUser = .init(userModel: user.adaptUserObservableModel())
                }
                return self.fetchFromFirestore.fetchConcurrentUserInfo(userIDs: userModel.user.pairRequestedUids)
            }
            .flatMap { users -> AnyPublisher<User?, AppError> in
                self.requestedPairUsers = users.map { .init(userModel: $0.adaptUserObservableModel()) }
                return self.fetchFromFirestore.fetchUserInfoFromFirestoreByUserID(uid: userModel.user.pairUid)
            }
            .flatMap { user -> AnyPublisher<[User], AppError> in
                if let user = user {
                    self.currentPairUser = .init(userModel: user.adaptUserObservableModel())
                }
                return self.fetchFromFirestore.fetchConcurrentUserInfo(userIDs: Array<String>(userModel.user.pairMapping.keys))
            }
            .sink { completion in
                switch completion {
                case .finished:
                    if let index = self.requestedPairUsers.firstIndex(where: { $0.user.uid == userModel.user.pairUid }) {
                        let pairUser = self.requestedPairUsers.remove(at: index)
                        self.requestedPairUsers.insert(pairUser, at: 0)
                    }
                case .failure(let error):
                    self.isErrorAlert = true
                    self.errorMessage = error.errorMessage
                }
            } receiveValue: { users in
                self.pastPairUsers = users.map { .init(userModel: $0.adaptUserObservableModel()) }
            }
            .store(in: &self.cancellable)
    }
    
    func searchUserByUid(userModel: UserObservableModel){
        if userModel.user.uid == searchQuery {
            self.isErrorAlert = true
            self.errorMessage = "自分のIDでの検索はできません。"
            return
        }
        
        fetchFromFirestore.fetchUserInfoFromFirestoreByUserID(uid: searchQuery)
            .sink { completion in
                switch completion {
                case .finished:
                    self.submit = true
                case .failure(let error):
                    self.isErrorAlert = true
                    self.errorMessage = error.errorMessage
                }
            } receiveValue: { user in
                if let user = user {
                    if user.pairRequestUid == userModel.user.uid {
                        self.isErrorAlert = true
                        self.errorMessage = "\(user.nickname)さんからは既にペアリクエストを受けています。"
                    } else if user.pairUid == userModel.user.uid {
                        self.isErrorAlert = true
                        self.errorMessage = "\(user.nickname)さんとは既にペアになっています。"
                    } else if user.pairRequestedUids.contains(userModel.user.uid) {
                        self.isErrorAlert = true
                        self.errorMessage = "\(user.nickname)さんには既にペアリクエストを送っています。"
                    } else {
                        self.searchResultUser = .init(userModel: user.adaptUserObservableModel())
                    }
                } else {
                    self.isErrorAlert = true
                    self.errorMessage = "指定されたIDを持つユーザーが存在しません。ご確認の上、再度お試しください。"
                }
            }
            .store(in: &self.cancellable)
    }
    
    func createPair(requestUser: UserObservableModel, requestedUser: UserObservableModel){
        setToFirestore.pairApprove(requestUser: requestUser, requestedUser: requestedUser)
            .sink { completion in
                switch completion {
                case .finished:
                    print("finished")
                case .failure(let error):
                    self.isErrorAlert = true
                    self.errorMessage = error.errorMessage
                }
            } receiveValue: { _ in
                print("recieve value")
            }
            .store(in: &self.cancellable)
    }
    
    func dissolvePair(requestUser: UserObservableModel, requestedUser:UserObservableModel){
        self.setToFirestore.changePairStatus(requestUser: requestUser, requestedUser: requestedUser)
            .sink { completion in
                switch completion {
                case .finished:
                    print("正常にペアを解除しました！")
                case .failure(let error):
                    self.isErrorAlert = true
                    self.errorMessage = error.errorMessage
                }
            } receiveValue: { _ in
                print("recieve value")
            }
            .store(in: &self.cancellable)
    }
    
    func cancelPair(requestingUser: UserObservableModel, requestedUser:UserObservableModel){
        self.setToFirestore
            .cancelPairRequest(requestingUser: requestingUser, requestedUser: requestedUser)
            .sink { completion in
                switch completion {
                case .finished:
                    print("succesfully pair request cancel")
                case .failure(let error):
                    self.isErrorAlert = true
                    self.errorMessage = error.errorMessage
                }
            } receiveValue: { _ in
                print("recieve value")
            }
            .store(in: &self.cancellable)

    }
}
