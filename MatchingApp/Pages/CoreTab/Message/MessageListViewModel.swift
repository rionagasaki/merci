//
//  GoodsListViewModel.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/06/03.
//

import Foundation
import Combine
import Firebase

class MessageListViewModel: ObservableObject {
    @Published var allChatmateUsers: [UserObservableModel] = []
    @Published var chatmateUsers: [UserObservableModel] = []
    @Published var chatmateKind: ChatmateKind = .all
    @Published var selectedChatPartnerUid: String = ""
    @Published var isSelectChatPairHalfModal: Bool = false
    @Published var isSelectedSuccess: Bool = false
    @Published var isErrorAlert: Bool = false
    @Published var errorMessage: String = ""
    
    private let userService = UserFirestoreService()
    private var cancellable = Set<AnyCancellable>()
    
    func fetchChatmateInfo(chatmateUsersMapping: [String: String], userModel: UserObservableModel) {
        let chatmateUids:[String] = Array<String>(chatmateUsersMapping.keys)
        self.userService.getConcurrentUserInfo(userIDs: chatmateUids)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("message reload success")
                case .failure(let error):
                    self.isErrorAlert = true
                    self.errorMessage = error.errorMessage
                }
            }, receiveValue: { chatmateUsers in
                self.allChatmateUsers = chatmateUsers.sorted(by: { user1, user2 in
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
    }
