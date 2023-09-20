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
    
    func signInWithEmail(email: String, password: String) -> AnyPublisher<AuthDataResult, AppError> {
        return Future<AuthDataResult, AppError> { promise in
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let error = error as? NSError {
                    print(error)
                    promise(.failure(.auth(AuthErrorCode(_nsError: error))))
                } else if let authResult = authResult {
                    promise(.success(authResult))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func signUpWithEmail(email: String, password: String) -> AnyPublisher<AuthDataResult, AppError> {
        return Future<AuthDataResult, AppError> { promise in
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let error = error as? NSError {
                    promise(.failure(.auth(AuthErrorCode(_nsError: error))))
                } else if let authResult = authResult {
                    promise(.success(authResult))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func signInWithApple(credential: OAuthCredential) -> AnyPublisher<AuthDataResult, AppError> {
        return Future<AuthDataResult, AppError> { promise in
            Auth.auth().signIn(with: credential){ authResult, error in
                if let error = error as? NSError {
                    promise(.failure(.auth(AuthErrorCode(_nsError: error))))
                } else if let authResult = authResult {
                    promise(.success(authResult))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func signInWithGoogle(credential: AuthCredential) -> AnyPublisher
    <AuthDataResult, AppError>{
        return Future<AuthDataResult, AppError> { promise in
            Auth.auth().signIn(with: credential){ authResult, error in
                if let error = error as NSError? {
                    promise(.failure(.auth(AuthErrorCode(_nsError: error))))
                } else if let authResult = authResult {
                    promise(.success(authResult))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func signOut() -> AnyPublisher<Void, AppError> {
        return Future<Void, AppError>{ promise in
            let firebaseAuth = Auth.auth()
            do {
                try firebaseAuth.signOut()
                promise(.success(()))
            } catch  {
                promise(.failure(.other(.unexpectedError)))
            }
        }.eraseToAnyPublisher()
    }
    
    func deleteAccount() -> AnyPublisher<Void, AppError> {
        return Future<Void, AppError> { promise in
            let currentUser = Auth.auth().currentUser
             currentUser?.delete { error in
                if let error = error {
                    promise(.failure(.other(.unexpectedError)))
                } else {
                    promise(.success(()))
                }
            }
        }.eraseToAnyPublisher()
    }
}
