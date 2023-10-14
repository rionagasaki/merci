//
//  ResoleveViewModel.swift
//  Merci
//
//  Created by Rio Nagasaki on 2023/10/07.
//

import Foundation

@MainActor
final class ResolveViewModel: ObservableObject {
    @Published var user: UserObservableModel? = nil
    @Published var isLoading: Bool = false
    @Published var resolveText: String = ""
    @Published var isSuccessfullyAddReply: Bool = false
    @Published var isErrorAlert: Bool = false
    @Published var errorMessage: String = ""
    @Published var chatRoomID: String?
    private let userService = UserFirestoreService()
    private let chatService = ChatFirestoreService()
    
    private func handlerError(error: Error) {
        if let error  = error as? AppError {
            self.errorMessage = error.errorMessage
        } else {
            self.errorMessage = error.localizedDescription
        }
        self.isErrorAlert = true
    }
    
    func getUserData(userID: String) async {
        do {
            let user = try await self.userService.getOneUser(uid: userID)
            self.user = .init(userModel: user.adaptUserObservableModel())
        } catch {
            handlerError(error: error)
        }
    }
    
    func addResolveChat(fromUser: UserObservableModel, concernID: String, concernKind: String, concernText: String, concernKindImageName: String) async {
        guard let user = user else { return }
        self.isLoading = true
        do {
            if let chatRoomID = fromUser.user.chatmateMapping[user.user.uid] {
                try await chatService.sendConcernMessage(
                    chatRoomId: chatRoomID,
                    fromUser: fromUser,
                    toUser: user,
                    createdAt: Date.init(),
                    message: self.resolveText,
                    concernID: concernID,
                    concernKind: concernKind,
                    concernText: concernText,
                    concernKindImageName: concernKindImageName
                )
            } else {
                try await chatService.createConcernChatRoonAndSendMessage(
                    message: self.resolveText,
                    concernID: concernID,
                    concernKind: concernKind,
                    concernText: concernText,
                    concernKindImageName: concernKindImageName,
                    fromUser: fromUser,
                    toUser: user,
                    createdAt: Date.init())
            }
            self.isLoading = false
            self.isSuccessfullyAddReply = true
        } catch {
            handlerError(error: error)
        }
    }
}
