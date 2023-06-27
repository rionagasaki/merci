//
//  LoginViewModel.swift
//  SNS
//
//  Created by Rio Nagasaki on 2022/12/29.
//

import SwiftUI

class EmailLoginViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var isVisibleValidateAlert: Bool = false
    @Published var isEmailEmpty: Bool = true
    @Published var isPasswordEmpty: Bool = true
    @Published var isModal: Bool = false
    @Published var registerSheet: Bool = false
    
    var isEnabledTappedLoginButton: Bool { !isEmailEmpty && !isPasswordEmpty }
    
    func signInWithEmail(completion:@escaping ()-> Void){
    }
    
    func signIn(username: String, password: String, email: String) async {
        
    }
    
    func validateEmail(){
        isEmailEmpty = email == ""
    }
    func validatePassword(){
        isPasswordEmpty = password == ""
    }
}



