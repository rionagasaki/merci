//
//  FriendListViewModel.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/07/04.
//

import Foundation
import Combine
import SwiftUI

@MainActor
final class PairSettingViewModel: ObservableObject {
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
    
    func initialFriendList(userModel: UserObservableModel) async {
        do {
            async let getRequestUsers = self.userService.getConcurrentUserInfo(userIDs: userModel.user.friendRequestUids)
            async let getRequestedUsers = self.userService.getConcurrentUserInfo(userIDs: userModel.user.friendRequestedUids)
            async let getFriendUsers = self.userService.getConcurrentUserInfo(userIDs: userModel.user.friendUids)
            
            let (requestUser, requestedUser, friendUsers) = try await (getRequestUsers, getRequestedUsers, getFriendUsers)
            
            self.requestFriendUsers = requestUser.map { .init(userModel: $0.adaptUserObservableModel()) }
            self.requestedFriendUsers = requestedUser.map { .init(userModel: $0.adaptUserObservableModel()) }
            self.friendUsers = friendUsers.map { .init(userModel: $0.adaptUserObservableModel()) }
        } catch let error as AppError {
            self.errorMessage = error.errorMessage
            self.isErrorAlert = true
        } catch {
            self.errorMessage = error.localizedDescription
            self.isErrorAlert = true
        }
    }
    
    func searchUserByUid(userID: String) async {
        if userID == searchQuery {
            self.isErrorAlert = true
            self.errorMessage = "自分のIDでの検索はできません。"
            return
        }
        
        do {
            let user = try await self.userService.getOneUser(uid: self.searchQuery)
            if user.friendRequestUids.contains(userID){
                self.isErrorAlert = true
                self.errorMessage = "\(user.nickname)さんからは既にペアリクエストを受けています。"
            }  else if user.friendRequestedUids.contains(userID) {
                self.isErrorAlert = true
                self.errorMessage = "\(user.nickname)さんには既にペアリクエストを送っています。"
            } else if user.friendUids.contains(userID) {
                self.isErrorAlert = true
                self.errorMessage = "\(user.nickname)さんとは既に友達になっています。"
            } else {
                self.searchResultUser = .init(userModel: user.adaptUserObservableModel())
            }
        } catch let error as AppError {
            self.errorMessage = error.errorMessage
            self.isErrorAlert = true
        } catch {
            self.errorMessage = error.localizedDescription
            self.isErrorAlert = true
        }
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
