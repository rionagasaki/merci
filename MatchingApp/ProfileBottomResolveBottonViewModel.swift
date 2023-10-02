//
//  ProfileBottomResolveBottonViewModel.swift
//  Merci
//
//  Created by Rio Nagasaki on 2023/09/27.
//

import Foundation
import Combine

class ProfileBottomResolveBottonViewModel: ObservableObject {
    @Published var isErrorAlert: Bool = false
    @Published var errorMessage: String = ""
    private let userService = UserFirestoreService()
    private var cancellable = Set<AnyCancellable>()
    
    func resolveBlock(userModel: UserObservableModel, user: UserObservableModel) {
        self.userService.resolveBlock(requestingUser: userModel, requestedUser: user)
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
