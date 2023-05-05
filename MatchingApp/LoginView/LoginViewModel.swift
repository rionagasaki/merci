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
    
    func validateEmail(){
        isEmailEmpty = emailText == ""
    }
    func validatePassword(){
        isPasswordEmpty = passwordText == ""
    }
}

