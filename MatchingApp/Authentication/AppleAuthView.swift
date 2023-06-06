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
    @EnvironmentObject var pairModel: PairObservableModel
    @State var isModal: Bool = false
    
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
                                self.userModel.subProfileImageURL = user.subProfileImageURLs
                                self.userModel.introduction = user.introduction
                                self.userModel.uid = user.id
                                self.userModel.hobbies = user.hobbies
                                self.userModel.pairID = user.pairID
                                self.userModel.requestUids = user.requestUids
                                self.userModel.requestedUids = user.requestedUids
                                
                                if userModel.pairID != "" {
                                    FetchFromFirestore().fetchCurrentUserPairInfo(pairID: userModel.pairID) { pair in
                                        pairModel.id = pair.id
                                        pairModel.gender = pair.gender
                                        pairModel.pair_1_uid = pair.pair_1_uid
                                        pairModel.pair_1_nickname = pair.pair_1_nickname
                                        pairModel.pair_1_profileImageURL = pair.pair_1_profileImageURL
                                        pairModel.pair_1_activeRegion = pair.pair_1_activeRegion
                                        pairModel.pair_1_birthDate = pair.pair_1_birthDate
                                        pairModel.pair_2_uid = pair.pair_2_uid
                                        pairModel.pair_2_nickname = pair.pair_2_nickname
                                        pairModel.pair_2_profileImageURL = pair.pair_2_profileImageURL
                                        pairModel.pair_2_activeRegion = pair.pair_2_activeRegion
                                        pairModel.pair_2_birthDate = pair.pair_2_birthDate
                                        pairModel.chatPairIDs = pair.chatPairIDs
                                        appState.isLogin = true
                                        appState.messageListViewInit = true
                                    }
                                } else {
                                    appState.isLogin = true
                                    appState.messageListViewInit = true
                                }
                            }
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
            NickNameView()
                .interactiveDismissDisabled()
        }
    }
}

struct AppleAuthView_Previews: PreviewProvider {
    static var previews: some View {
        AppleAuthView()
    }
}
