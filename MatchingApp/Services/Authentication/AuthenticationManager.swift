//
//  isLogin.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/21.
//

import Foundation
import FirebaseAuth

final class AuthenticationManager: ObservableObject {
    static let shared = AuthenticationManager()
    
    @Published var user: FirebaseAuth.User? = Auth.auth().currentUser
    
    private var authHandle: AuthStateDidChangeListenerHandle?
    
    private init() {
        authHandle = Auth.auth().addStateDidChangeListener { [weak self] (auth, user) in
            self?.user = auth.currentUser
        }
        
        
    }
    
    deinit {
        if let handle = authHandle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
    
    
}
