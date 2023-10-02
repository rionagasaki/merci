//
//  ReAuthenticationViewModel.swift
//  Merci
//
//  Created by Rio Nagasaki on 2023/09/27.
//

import Foundation
import Combine
import CryptoKit
import AuthenticationServices
import GoogleSignIn
import Firebase

class ReAuthenticationViewModel: ObservableObject {
    private var autheication = AuthenticationManager.shared.user
    @Published var provider = AuthProvider(rawValue: "")
    @Published var currentNonce: String?
    @Published var isSuccess: Bool = false
    @Published var isErrorAlert: Bool = false
    @Published var errorMessage: String = ""
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
    
    func handleResult(result: (Result<ASAuthorization, Error>)){
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
            self.reAuthentication(credential: credential)
           
        case .failure(let error):
            print("Authentication failed: \(error.localizedDescription)")
            break
        }
    }
    
    func googleAuth(){
        guard let clientID:String = FirebaseApp.app()?.options.clientID else { return }
        let config:GIDConfiguration = GIDConfiguration(clientID: clientID)
        
        if let windowScene:UIWindowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let rootViewController:UIViewController = windowScene.windows.first?.rootViewController! {
            GIDSignIn.sharedInstance.configuration = config
            
            GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController) { result, error in
                guard error == nil else {
                    print("GIDSignInError: \(error!.localizedDescription)")
                    return
                }
                
                guard let user = result?.user,
                      let idToken = user.idToken?.tokenString
                else {
                    return
                }
            
                let credential = GoogleAuthProvider.credential(withIDToken: idToken,accessToken: user.accessToken.tokenString)
                self.reAuthentication(credential: credential)
            }
        }
    }
    
    func reAuthentication(credential: AuthCredential){
        AuthenticationService
            .shared
            .reAuthentication(credential: credential)
            .sink { completion in
                switch completion {
                case .finished:
                    self.isSuccess = true
                    break
                case .failure(let error):
                    self.errorMessage = error.errorMessage
                    self.isErrorAlert = true
                }
            } receiveValue: { _ in }
            .store(in: &cancellable)
    }

    func initial(){
        if let providerID = autheication?.providerData[0].providerID {
            self.provider = AuthProvider(rawValue: providerID)
        }
    }
}
