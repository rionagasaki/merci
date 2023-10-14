//
//  BlockedUserListViewModel.swift
//  Merci
//
//  Created by Rio Nagasaki on 2023/09/22.
//

import Foundation
import Combine
import SwiftUI

@MainActor
final class BlockedUserListViewModel: ObservableObject {
    @Published var errorMessage: String = ""
    @Published var isErrorAlert: Bool = false
    @Published var isLoading: Bool = false
    @Published var blockedUser: [UserObservableModel] = []
    private let userService = UserFirestoreService()
    private var cancellable = Set<AnyCancellable>()
    
    func initial(userModel: UserObservableModel) async {
        do {
            let users = try await self.userService.getConcurrentUserInfo(userIDs: userModel.user.blockingUids)
            self.blockedUser = users.map { .init(userModel: $0.adaptUserObservableModel()) }
        } catch let error as AppError {
            self.errorMessage = error.errorMessage
            self.isErrorAlert = true
        } catch {
            self.errorMessage = error.localizedDescription
            self.isErrorAlert = true
        }
    }
    
    func resolveBlock(userModel: UserObservableModel, user: UserObservableModel) {
        self.userService.resolveBlock(requestingUser: userModel, requestedUser: user)
            .sink { completion in
                switch completion {
                case .finished:
                    withAnimation {
                        self.blockedUser = self.blockedUser.filter { $0.user.uid != user.user.uid }
                    }
                    break
                case .failure(let error):
                    self.errorMessage = error.errorMessage
                    self.isErrorAlert = true
                }
            } receiveValue: { _ in }.store(in: &self.cancellable)
    }
}
