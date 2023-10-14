//
//  AuthenticationService.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/07/02.
//

import Foundation
import FirebaseAuth
import Combine

class AuthenticationService {
    static let shared = AuthenticationService()
    private init(){}
    
    func reAuthentication(credential: AuthCredential) -> AnyPublisher<Void, AppError>{
        return Future { promise in
            Auth.auth().currentUser?.reauthenticate(with: credential){ result, error in
                if let error = error {
                    promise(.failure(.firestore(error)))
                } else {
                    promise(.success(()))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func signInWithEmail(email: String, password: String) async throws -> AuthDataResult {
        let result = try await Auth.auth().signIn(withEmail: email, password: password)
        return result
    }
    
    func signUpWithEmail(email: String, password: String) async throws -> AuthDataResult {
        let result = try await Auth.auth().createUser(withEmail: email, password: password)
        return result
    }
    
    func signInWithApple(credential: OAuthCredential) async throws -> AuthDataResult {
        let result = try await Auth.auth().signIn(with: credential)
        return result
    }
    
    func signInWithGoogle(credential: AuthCredential) async throws -> AuthDataResult {
        let result = try await Auth.auth().signIn(with: credential)
        return result
    }
    
    func signOut() async throws -> Void {
        try Auth.auth().signOut()
    }
    
    func deleteAccount() -> AnyPublisher<Void, AppError> {
        return Future<Void, AppError> { promise in
            let currentUser = Auth.auth().currentUser
            
            currentUser?.delete { error in
                if let error = error as? AuthErrorCode {
                    if  error.code == .requiresRecentLogin {
                        promise(.failure(.firestore(error)))
                        
                    }
                } else {
                    promise(.success(()))
                }
            }
        }.eraseToAnyPublisher()
    }
}
