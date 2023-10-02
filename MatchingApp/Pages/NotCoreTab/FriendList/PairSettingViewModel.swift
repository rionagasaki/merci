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
    @Published var friendUsers: [UserObservableModel] = []
    @Published var requestedFriendUsers: [UserObservableModel] = []
    @Published var requestFriendUsers: [UserObservableModel] = []
    @Published var searchResultUser: UserObservableModel?
    @Published var searchQuery: String = ""
    @Published var submit: Bool = false
    @Published var requestPairRequestCancelModal: Bool = false
    @Published var isErrorAlert: Bool = false
    @Published var errorMessage: String = ""
    
    private let userService = UserFirestoreService()
    let UIIFGeneratorMedium = UIImpactFeedbackGenerator(style: .medium)
    private var cancellable = Set<AnyCancellable>()
    
    func initialFriendList(userModel: UserObservableModel){
        self.userService.getConcurrentUserInfo(userIDs: userModel.user.friendRequestUids)
            .flatMap { users -> AnyPublisher<[User], AppError> in
                self.requestFriendUsers = users.map { .init(userModel: $0.adaptUserObservableModel()) }
                return self.userService.getConcurrentUserInfo(userIDs: userModel.user.friendRequestedUids)
            }
            .flatMap { users -> AnyPublisher<[User], AppError> in
                self.requestedFriendUsers = users.map { .init(userModel: $0.adaptUserObservableModel()) }
                return self.userService.getConcurrentUserInfo(userIDs: userModel.user.friendUids
                )
            }
            .sink { completion in
                switch completion {
                case .finished:
                    print("finished")
                case .failure(let error):
                    self.isErrorAlert = true
                    self.errorMessage = error.errorMessage
                }
            } receiveValue: { users in
                self.friendUsers = users.map { .init(userModel: $0.adaptUserObservableModel()) }
            }
            .store(in: &self.cancellable)
    }
    
    func searchUserByUid(userID: String){
        if userID == searchQuery {
            self.isErrorAlert = true
            self.errorMessage = "自分のIDでの検索はできません。"
            return
        }
        
        self.userService.searchUser(uid: self.searchQuery)
            .sink { completion in
                switch completion {
                case .finished:
                    self.submit = true
                case .failure(let error):
                    self.isErrorAlert = true
                    self.errorMessage = error.errorMessage
                }
            } receiveValue: { [weak self] user in
                guard let weakSelf = self else { return }
                if let user = user {
                    if user.friendRequestUids.contains(userID){
                        weakSelf.isErrorAlert = true
                        weakSelf.errorMessage = "\(user.nickname)さんからは既にペアリクエストを受けています。"
                    }  else if user.friendRequestedUids.contains(userID) {
                        weakSelf.isErrorAlert = true
                        weakSelf.errorMessage = "\(user.nickname)さんには既にペアリクエストを送っています。"
                    } else if user.friendUids.contains(userID) {
                        weakSelf.isErrorAlert = true
                        weakSelf.errorMessage = "\(user.nickname)さんとは既に友達になっています。"
                    } else {
                        weakSelf.searchResultUser = .init(userModel: user.adaptUserObservableModel())
                    }
                } else {
                    weakSelf.isErrorAlert = true
                    weakSelf.errorMessage = "指定されたIDを持つユーザーが存在しません。ご確認の上、再度お試しください。"
                }
            }
            .store(in: &self.cancellable)
    }
    
    func approveRequest(requestUser: UserObservableModel, requestedUser: UserObservableModel){
        self.userService.approveRequest(requestUser: requestUser, requestedUser: requestedUser)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.isErrorAlert = true
                    self.errorMessage = error.errorMessage
                }
            } receiveValue: { _ in }
            .store(in: &self.cancellable)
    }
    
    func requestFriend(requestingUser: UserObservableModel, requestedUser: UserObservableModel){
        
        self.userService.requestFriend(requestingUser: requestingUser, requestedUser: requestedUser)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.isErrorAlert = true
                    self.errorMessage = error.errorMessage
                }
            } receiveValue: { _ in }
            .store(in: &self.cancellable)
    }
    
    func cancelFriendRequest(requestingUser: UserObservableModel, requestedUser:UserObservableModel){
        self.userService.cancelFriendRequest(requestingUser: requestingUser, requestedUser: requestedUser)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.isErrorAlert = true
                    self.errorMessage = error.errorMessage
                }
            } receiveValue: { _ in }
            .store(in: &self.cancellable)
    }
}
