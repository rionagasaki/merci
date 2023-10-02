//
//  RequestNoticeCellViewModel.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/09/04.
//

import Foundation
import Combine

class RequestNoticeCellViewModel: ObservableObject {
    @Published var isErrorAlert: Bool = false
    @Published var errorMessage: String = ""
    private let userService = UserFirestoreService()
    private var cancellable = Set<AnyCancellable>()

    func approveFriend(requestUser: UserObservableModel, requestedUserID: String){
        self.userService.getUser(uid: requestedUserID)
            .flatMap { userModel in
                let requestedUser = UserObservableModel(userModel: userModel)
                return self.userService.approveRequest(requestUser: requestUser, requestedUser: requestedUser)
            }
            .sink { completion in
                switch completion {
                case .finished:
                    
                  break
                case .failure(let error):
                    self.isErrorAlert = true
                    self.errorMessage = error.errorMessage
                }
            } receiveValue: { _ in }.store(in: &self.cancellable)
    }
}
