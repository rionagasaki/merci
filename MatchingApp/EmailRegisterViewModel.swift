//
//  EmailRegisterViewModel.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/06/16.
//

import Foundation
import Combine

class EmailRegisterViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isErrorAlert: Bool = false
    @Published var errorMessage: String = ""
    @Published var isAvailableEmail: Bool = true
    @Published var isAvailablePassword: Bool = true
    
    var isEnabledTappedLoginButton: Bool { isAvailableEmail && isAvailablePassword }
    private var cancellable = Set<AnyCancellable>()
    private let userService = UserFirestoreService()
    
    
    func isValidPassword() {
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "(?=.*[0-9])(?=.*[a-z])[a-z0-9]{8,}")
        self.isAvailablePassword = passwordTest.evaluate(with: password)
    }
    
    func isValidEmail()  {
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        self.isAvailableEmail = emailPredicate.evaluate(with: email)
    }

    func signUpEmail(appState: AppState){
        AuthenticationService.shared.signUpWithEmail(email: self.email, password: self.password)
            .flatMap { authResult -> AnyPublisher<Void, AppError> in
                let email = authResult.user.email ?? ""
                let uid = authResult.user.uid
                return self.userService.registerUserEmailAndUid(email: email, uid: uid)
            }
            .sink { completion in
                switch completion {
                case .finished:
                    print("successfully signUp")
                case .failure(let error):
                    self.errorMessage = error.errorMessage
                    self.isErrorAlert = true
                }
            } receiveValue: { _ in
                self.email = ""
                self.password = ""
            }
            .store(in: &self.cancellable)
    }
}
