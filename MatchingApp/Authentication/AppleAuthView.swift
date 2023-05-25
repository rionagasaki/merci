//
//  AppleAuthView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/22.
//

import SwiftUI
import CryptoKit
import AuthenticationServices
import FirebaseAuth

struct AppleAuthView: View {
    @State var currentNonce: String?
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var userModel: UserObservableModel
    @State var isModal: Bool = false
    @StateObject var viewModel = UserObservableModel()
    
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
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
    }
    
    var body: some View {
        SignInWithAppleButton(.signIn){ request in
            request.requestedScopes = [.email,.fullName]
            let nonce = randomNonceString()
            currentNonce = nonce
            request.nonce = sha256(nonce)
        } onCompletion: { result in
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
                
                Auth.auth().signIn(with: credential) { result, error in
                    if error != nil, result == nil { return }
                    if let additionalUserInfo = result?.additionalUserInfo {
                        
                        if additionalUserInfo.isNewUser {
                            isModal = true
                        } else {
                            FetchFromFirestore().fetchUserInfoFromFirestore { user in
                                self.userModel.nickname = user.nickname
                                self.userModel.email = user.email
                                self.userModel.activeRegion = user.activityRegion
                                self.userModel.birthDate = user.birthDate
                                self.userModel.gender = user.gender
                                self.userModel.profileImageURL = user.profileImageURL
                            }
                            appState.isLogin = true
                        }
                    }
                }
                
            case .failure(let error):
                print("Authentication failed: \(error.localizedDescription)")
                break
            }
        }
        .signInWithAppleButtonStyle(.black)
        .frame(width: 224, height: 40)
        .sheet(isPresented: $isModal) {
            NickNameView(viewModel: viewModel)
                .interactiveDismissDisabled()
        }
    }
}

struct AppleAuthView_Previews: PreviewProvider {
    static var previews: some View {
        AppleAuthView()
    }
}
