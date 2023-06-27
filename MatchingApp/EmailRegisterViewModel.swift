//
//  EmailRegisterViewModel.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/06/16.
//

import Foundation
class EmailRegisterViewModel: ObservableObject {
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
    
    func isValidPassword() -> Bool {
        // 8文字以上英数字
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "(?=.*[0-9])(?=.*[a-z])[a-z0-9]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    func isValidEmail() -> Bool {
        // 一般的なメールアドレスバリデーション
        let emailFormat = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailFormat)
        return emailPredicate.evaluate(with: email)
    }

    
    func validateEmail(){
        isEmailEmpty = email == ""
    }
}
