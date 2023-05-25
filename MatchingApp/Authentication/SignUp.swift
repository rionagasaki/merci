//
//  SignUp.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/21.
//

import Foundation
import FirebaseAuth

class SignUp {
    static let shared = SignUp()
    private init(){}
    func handleSignUp(email: String, password: String, completion: @escaping(Result<AuthDataResult, Error>)->Void) {
        Auth.auth().createUser(withEmail: email, password: password){ authResult, error in
            guard let authResult = authResult else { return }
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(authResult))
            }
        }
    }
}
