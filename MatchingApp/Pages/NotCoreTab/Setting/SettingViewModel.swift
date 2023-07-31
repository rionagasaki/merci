//
//  SettingViewModel.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/07/16.
//

import Foundation
import Combine

class SettingViewModel: ObservableObject {
    @Published var isSuccess: Bool = false
    @Published var isErrorAlert: Bool = false
    @Published var errorMessage: String = ""
    
    private var cancellable = Set<AnyCancellable>()
    
    func signOut(){
        AuthenticationService.shared.signOut()
            .sink { completion in
                switch completion {
                case .finished:
                    self.isSuccess = true
                case .failure(let error):
                    self.isErrorAlert = true
                    self.errorMessage = error.errorMessage
                }
            } receiveValue: { _ in
                print("recieve value")
            }
            .store(in: &self.cancellable)
    }
}
