//
//  HiddenChatUserListViewMode.swift
//  Merci
//
//  Created by Rio Nagasaki on 2023/09/22.
//

import Foundation
import Combine
import SwiftUI

@MainActor
final class HiddenChatUserListViewModel: ObservableObject {
    @Published var hiddenChatUsers:[UserObservableModel] = []
    @Published var isErrorAlert: Bool = false
    @Published var errorMessage: String = ""
    private let userService = UserFirestoreService()
    private var cancellable = Set<AnyCancellable>()
    
    func initial(userModel: UserObservableModel) async {
        do {
            let users = try await self.userService.getConcurrentUserInfo(userIDs: userModel.user.hiddenChatRoomUserIDs)
            self.hiddenChatUsers = users.map { .init(userModel: $0.adaptUserObservableModel()) }
        } catch let error as AppError {
            self.errorMessage = error.errorMessage
            self.isErrorAlert = true
        } catch {
            self.errorMessage = error.localizedDescription
            self.isErrorAlert = true
        }
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
