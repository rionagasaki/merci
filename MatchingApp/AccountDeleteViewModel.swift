//
//  AccountDeleteViewModel.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/09/10.
//

import Foundation
import Combine

class AccountDeleteViewModel: ObservableObject {
    @Published var errorMessage: String = ""
    @Published var isRequiredReAuthentication: Bool = false
    @Published var isDeleteAccountAlert: Bool = false
    @Published var isSuccessDeleteAccount: Bool = false
    @Published var isErrorAlert: Bool = false
    private var cancellable = Set<AnyCancellable>()
    
    func deleteAccount(){
        AuthenticationService.shared.deleteAccount()
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.isRequiredReAuthentication = true
                    self.errorMessage = error.errorMessage
                    self.isErrorAlert = true
                }
            } receiveValue: { _ in }
            .store(in: &self.cancellable)
    }
}
