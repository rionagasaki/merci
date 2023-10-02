//
//  HiddenChatUserListViewMode.swift
//  Merci
//
//  Created by Rio Nagasaki on 2023/09/22.
//

import Foundation
import Combine
import SwiftUI

class HiddenChatUserListViewModel: ObservableObject {
    @Published var hiddenChatUsers:[UserObservableModel] = []
    @Published var isErrorAlert: Bool = false
    @Published var errorMessage: String = ""
    private let userService = UserFirestoreService()
    private var cancellable = Set<AnyCancellable>()
    
    func initial(userModel: UserObservableModel) {
        self.userService.getConcurrentUserInfo(userIDs: userModel.user.hiddenChatRoomUserIDs)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.errorMessage = error.errorMessage
                    self.isErrorAlert = true
                }
            } receiveValue: { users in
                self.hiddenChatUsers = users.map { .init(userModel: $0.adaptUserObservableModel()) }
            }.store(in: &self.cancellable)
    }
    
    func resolveHiddenChatRoom(fromUserModel: UserObservableModel, toUserID: String) {
        self.userService.resolveChatRoomHidden(fromUserID: fromUserModel.user.uid, toUserID: toUserID)
            .sink { completion in
                switch completion {
                case .finished:
                    withAnimation {
                        self.hiddenChatUsers = self.hiddenChatUsers.filter { !($0.user.uid == toUserID) }
                    }
                case .failure(let error):
                    self.errorMessage = error.errorMessage
                    self.isErrorAlert = true
                }
            } receiveValue: { _ in }.store(in: &self.cancellable)
    }
}
