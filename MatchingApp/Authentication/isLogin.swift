//
//  isLogin.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/21.
//

import Foundation
import FirebaseAuth

class Authentication {
    let currentUser: FirebaseAuth.User?
    let userEmail: String
    let currentUid: String
    
    init(){
        self.currentUser = Auth.auth().currentUser
        self.currentUid = Auth.auth().currentUser?.uid ?? ""
        self.userEmail = Auth.auth().currentUser?.email ?? ""
    }
}
