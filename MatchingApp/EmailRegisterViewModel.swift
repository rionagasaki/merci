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

    func signUpEmail(appState: AppState) async {
        do {
            let result = try await AuthenticationService.shared.signUpWithEmail(email: self.email, password: self.password)
            let email = result.user.email ?? ""
            let uid = result.user.uid
            try await self.userService.registerUserEmailAndUid(email: email, uid: uid)
        } catch let error as AppError {
            self.errorMessage = error.errorMessage
            self.isErrorAlert = true
        } catch {
            self.errorMessage = error.localizedDescription
            self.isErrorAlert = true
        }
    }
}
