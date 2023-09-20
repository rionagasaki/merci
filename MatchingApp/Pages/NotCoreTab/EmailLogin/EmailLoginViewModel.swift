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
    ){
        AuthenticationService.shared.signInWithEmail(email: self.email, password: self.password)
            .flatMap { result in
                userModel.user.uid = result.user.uid
                return self.userService.updateUserInfo(currentUid: userModel.user.uid, key: "fcmToken", value: self.tokenData.token)
            }
            .sink { completion in
                switch completion {
                case .finished:
                    print("successufully login")
                case .failure(let error):
                    self.isErrorAlert = true
                    self.errorMessage = error.errorMessage
                }
            } receiveValue: { _ in }
            .store(in: &cancellable)
    }
}



