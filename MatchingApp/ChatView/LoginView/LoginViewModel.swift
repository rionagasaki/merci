//
//  LoginViewModel.swift
//  SNS
//
//  Created by Rio Nagasaki on 2022/12/29.
//

import SwiftUI

class LoginViewModel: ObservableObject {
    @Published var emailText: String = ""
    @Published var passwordText: String = ""
    @Published var isVisibleValidateAlert: Bool = false
    @Published var isEmailEmpty: Bool = true
    @Published var isPasswordEmpty: Bool = true
    
    var isEnabledTappedLoginButton: Bool { !isEmailEmpty && !isPasswordEmpty }
    
    func signInWithEmail(completion:@escaping ()-> Void){
        
    }
    
    func validateEmail() -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: emailText)
//        isEmailEmpty = emailText == ""
    }
    
    // Password should be longer than 8 and shorter than 25 characters.
    // Also, it should be included at least one capital, number.
    func validatePassword() -> Bool {
        let passwardRegEx = "^(?=.*[A-Z])(?=.*[0-9])[a-zA-Z0-9]{8,24}$"
        let passwardPred = NSPredicate(format: "SELF MATCHES %@", passwardRegEx)
        return passwardPred.evaluate(with: passwordText)
//        isPasswordEmpty = passwordText == ""
    }
}

