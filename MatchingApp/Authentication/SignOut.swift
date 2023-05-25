//
//  SignOut.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/21.
//

import Foundation
import FirebaseAuth

class SignOut {
    static let shared = SignOut()
    private init(){}
    
    func signOut(completion: @escaping()-> Void) {
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
          completion()
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
}
