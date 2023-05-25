//
//  RegisterViewModel.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/01.
//

import SwiftUI

class RegisterViewModel: ObservableObject {
    @Published var username: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var verificationCode: String = ""
    
    @Published var modal: Bool = false
    
    func signUp() async {
       
    }
    
    func confirmSignUp() async {
        
    }
    
    func socialSignInWithWebUI() async {
     
    }
}

