//
//  AppleAuthViewModel.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/07/03.
//
import Foundation
import SwiftUI
import AuthenticationServices
import CryptoKit
import FirebaseAuth
import Combine

class AppleAuthViewModel: ObservableObject {
    @Published var currentNonce: String?
    @Published var isErrorAlert: Bool = false
    @Published var errorMessage: String = ""
    @ObservedObject var tokenData = TokenData.shared
    private let userService = UserFirestoreService()
    private var cancellable = Set<AnyCancellable>()
        
    func handleRequest(request: ASAuthorizationAppleIDRequest){
        request.requestedScopes = [.email,.fullName]
        let nonce = randomNonceString()
        currentNonce = nonce
        request.nonce = sha256(nonce)
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError(
                "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
        }
        
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        
        let nonce = randomBytes.map { byte in
            // Pick a random character from the set, wrapping around if needed.
            charset[Int(byte) % charset.count]
        }
        return String(nonce)
    }
    
    func handleResult(result: (Result<ASAuthorization, Error>), userModel: UserObservableModel, appState: AppState){
        switch result {
        case .success(let authResults):
            let appleIDCredential = authResults.credential as? ASAuthorizationAppleIDCredential
            
            guard let nonce = currentNonce else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            
            guard let appleIDToken = appleIDCredential?.identityToken else {
                fatalError("Invalid state: A login callback was received, but no login request was sent.")
            }
            
            guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                return
            }
            
            let credential = OAuthProvider.credential(withProviderID: "apple.com",idToken: idTokenString,rawNonce: nonce)
            
            AuthenticationService
                .shared
                .signInWithApple(credential: credential)
                .flatMap { authResult -> AnyPublisher<Void, AppError> in
                    guard let additionalUserInfo = authResult.additionalUserInfo else { return Just(()).setFailureType(to: AppError.self).eraseToAnyPublisher() }
                    if !additionalUserInfo.isNewUser { return Just(()).setFailureType(to: AppError.self).eraseToAnyPublisher() }
                    let email = authResult.user.email ?? ""
                    let uid = authResult.user.uid
                    return self.userService.registerUserEmailAndUid(email: email, uid: uid)
                }
                .sink { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self.errorMessage = error.errorMessage
                        self.isErrorAlert = true
                    }
                } receiveValue: { _ in }
                .store(in: &cancellable)
        case .failure(let error):
            print("Authentication failed: \(error.localizedDescription)")
            break
        }
    }
}
