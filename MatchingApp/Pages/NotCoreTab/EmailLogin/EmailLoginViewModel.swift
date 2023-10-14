//
//  LoginViewModel.swift
//  SNS
//
//  Created by Rio Nagasaki on 2022/12/29.
//

import SwiftUI
import Combine

class EmailLoginViewModel: ObservableObject {
    private let userService = UserFirestoreService()
    @Published var username: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isVisibleValidateAlert: Bool = false
    @Published var isEmailEmpty: Bool = true
    @Published var isPasswordEmpty: Bool = true
    
    @Published var isErrorAlert: Bool = false
    @Published var errorMessage: String = ""
    
    @ObservedObject var tokenData = TokenData.shared
    private var cancellable = Set<AnyCancellable>()
    
    var isEnabledTappedLoginButton: Bool { !isEmailEmpty && !isPasswordEmpty }
    
    
    func validateEmail(){
        isEmailEmpty = email == ""
    }
    func validatePassword(){
        isPasswordEmpty = password == ""
    }
    
    func signInWithEmail(
        userModel: UserObservableModel,
        appState: AppState
    ) async {
        do {
            let authResult = try await AuthenticationService.shared.signInWithEmail(email: self.email, password: self.password)
            try await self.userService.updateUserInfo(currentUid: userModel.user.uid, key: "fcmToken", value: self.tokenData.token)
        } catch let error as AppError {
            self.errorMessage = error.errorMessage
            self.isErrorAlert = true
        } catch {
            self.errorMessage = error.localizedDescription
            self.isErrorAlert = true
        }
    }
}



