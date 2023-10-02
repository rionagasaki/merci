//
//  BlockingUserProfileViewModel.swift
//  Merci
//
//  Created by Rio Nagasaki on 2023/09/22.
//

import Foundation
import Combine

class BlockingUserProfileBottomViewModel: ObservableObject {
    @Published var isErrorAlert: Bool = false
    @Published var errorMessage: String = ""
    private let userService = UserFirestoreService()
    private var cancellable = Set<AnyCancellable>()
    
    func resolveBlock(requestingUser: UserObservableModel, requestedUser: UserObservableModel) {
        self.userService
            .resolveBlock(requestingUser: requestingUser, requestedUser: requestedUser)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.errorMessage = error.errorMessage
                    self.isErrorAlert = true
                }
            } receiveValue: { _ in }.store(in: &self.cancellable)
    }
}
