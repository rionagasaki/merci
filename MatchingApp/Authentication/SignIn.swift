//
//  SignIn.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/21.
//

import Foundation
import FirebaseAuth

class SignIn {
    static let shared = SignIn()
    private init(){}
    
    func signInWithEmail(email: String, password: String, completion: @escaping (Result<AuthDataResult, Error>)-> Void){
        Auth.auth().signIn(withEmail: email, password: password){ authResult, error in
            guard let authResult = authResult else { return }
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(authResult))
            }
        }
    }
    
    func signInWithApple(){
        
    }
}
