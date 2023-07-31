//
//  isLogin.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/21.
//

import Foundation
import FirebaseAuth

class AuthenticationManager {
    static let shared = AuthenticationManager()
    
    var user: FirebaseAuth.User? {
        return Auth.auth().currentUser
    }
    
    var uid: String? {
        return Auth.auth().currentUser?.uid
    }
    
    var email: String? {
        return Auth.auth().currentUser?.email
    }
        
    private init(){}
}
