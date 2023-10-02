//
//  GoodsListViewModel.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/06/03.
//
import Combine
import SwiftUI

class MessageListViewModel: ObservableObject {
    @Published var allChatmateUsers: [UserObservableModel] = []
    @Published var chatmateUsers: [UserObservableModel] = []
    @Published var onlineUsers: [UserObservableModel] = []
    @Published var chatmateKind: ChatmateKind = .all
    @Published var selectedChatPartnerUid: String = ""
    @Published var isSelectChatPairHalfModal: Bool = false
    @Published var isSelectedSuccess: Bool = false
    @Published var isLoading: Bool = false
    @Published var isErrorAlert: Bool = false
    @Published var errorMessage: String = ""
    
    private let userService = UserFirestoreService()
    private var cancellable = Set<AnyCancellable>()
    
    func fetchOnlineUser(userID: String){
        self.userService.getOnlineUser(userID: userID)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.errorMessage = error.errorMessage
                    self.isErrorAlert = true
                }
            } receiveValue: { [weak self] users in
                guard let weakSelf = self else { return }
                weakSelf.onlineUsers = users.map { .init(userModel: $0) }
            }.store(in: &self.cancellable)
    }
    
    func fetchChatmateInfo(chatmateUsersMapping: [String: String], userModel: UserObservableModel) {
        self.isLoading = true
        let chatmateUids:[String] = Array<String>(chatmateUsersMapping.keys)
        self.userService.getConcurrentUserInfo(userIDs: chatmateUids)
            .sink(receiveCompletion: { [weak self] completion in
                guard let weakSelf = self else { return }
                switch completion {
                case .finished:
                    weakSelf.isLoading = false
                case .failure(let error):
                    weakSelf.isErrorAlert = true
                    weakSelf.errorMessage = error.errorMessage
                }
            }, receiveValue: { [weak self] chatmateUsers in
                guard let weakSelf = self else { return }
                if chatmateUsers.map({ .init(userModel: $0.adaptUserObservableModel()) })  == weakSelf.allChatmateUsers { return }
                weakSelf.allChatmateUsers = chatmateUsers.filter{
                    !userModel.user.hiddenChatRoomUserIDs.contains($0.id) &&
                    !userModel.user.blockedUids.contains($0.id) &&
                    !userModel.user.blockingUids.contains($0.id) }.sorted(by: { user1, user2 in
                    let chatRoomId1 = userModel.user.chatmateMapping[user1.id]!
                    let chatRoomId2 = userModel.user.chatmateMapping[user2.id]!
                    if let lastMessageCreatedAt1 = userModel.user.chatLastMessageTimestamp[chatRoomId1],
                       let lastMessageCreatedAt2 = userModel.user.chatLastMessageTimestamp[chatRoomId2] {
                        return lastMessageCreatedAt1.seconds > lastMessageCreatedAt2.seconds
                    } else {
                        return true
                    }
                }).map { .init(userModel: $0.adaptUserObservableModel()) }
            })
            .store(in: &self.cancellable)
        }
    
    func setChatRoomHidden(fromUserID:String, toUserID: String) {
        self.userService.updateChatRoomHidden(fromUserID: fromUserID, toUserID: toUserID)
            .sink { completion in
                switch completion {
                case .finished:
                    if self.chatmateUsers.count != 0 {
                        withAnimation {
                            self.chatmateUsers = self.chatmateUsers.filter { $0.user.uid != toUserID }
                        }
                    } else {
                        withAnimation {
                            self.allChatmateUsers = self.allChatmateUsers.filter { $0.user.uid != toUserID }
                        }
                    }
                case .failure(let error):
                    self.errorMessage = error.errorMessage
                    self.isErrorAlert = true
                }
            } receiveValue: { _ in }.store(in: &self.cancellable)
    }
}
