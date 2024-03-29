//
//  UserProfileBottomBarViewModel.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/08/22.
//

import Foundation
import Combine

class UserProfileBottomViewModel: ObservableObject {
    enum AlertType {
        case requestFriend
        case deleteFriend
        case blockUser
    }
    
    @Published var alertType: AlertType = .requestFriend
    @Published var isAlert: Bool = false
    @Published var isActionSheet: Bool = false
    private let userService = UserFirestoreService()
    private var cancellabel = Set<AnyCancellable>()
    
    func requestFriend(requestingUser: UserObservableModel, requestedUser: UserObservableModel){
        self.userService.requestFriend(requestingUser: requestingUser, requestedUser: requestedUser)
            .sink { completion in
                switch completion {
                case .finished:
                    print("finished")
                case .failure(let error):
                    print(error)
                }
            } receiveValue: { _ in }
            .store(in: &self.cancellabel)
    }
    
    func cancelRequestFriend(requestingUser: UserObservableModel, requestedUser: UserObservableModel){
        self.userService.cancelFriendRequest(requestingUser: requestingUser, requestedUser: requestedUser)
            .sink { completion in
                switch completion {
                case .finished:
                    print("successfully cancel")
                case .failure(let error):
                    print(error)
                }
            } receiveValue: { _ in }
            .store(in: &self.cancellabel)
    }
    
    func approveFriendRequest(requestingUser: UserObservableModel, requestedUser: UserObservableModel){
        self.userService.approveRequest(requestUser: requestingUser, requestedUser: requestedUser)
            .sink { completion in
                switch completion {
                case .finished:
                    print("successfully cancel")
                case .failure(let error):
                    print(error)
                }
            } receiveValue: { _ in }
            .store(in: &self.cancellabel)
    }
    
    func deleteFriend(requestingUser: UserObservableModel, requestedFriend: UserObservableModel) {
        self.userService.deleteUser(requestingUser: requestingUser, requestedUser: requestedFriend)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error)
                }
            } receiveValue: { _ in }
            .store(in: &self.cancellabel)
    }
    
    func blockedUser(requestingUser: UserObservableModel, requestedUser: UserObservableModel) {
        self.userService.blockUser(
            requestingUser: requestingUser,
            requestedUser: requestedUser
        ).sink { completion in
            switch completion {
            case .finished:
                break
            case .failure(let error):
                print(error)
            }
        } receiveValue: { _ in }
        .store(in: &self.cancellabel)
    }
}
