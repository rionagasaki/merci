//
//  AppleRegisterView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/06/17.
//

import SwiftUI
import CryptoKit
import AuthenticationServices
import FirebaseAuth

struct AppleRegisterView: View {
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
        SignInWithAppleButton(.signUp){ request in
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
                print("Email!!", appleIDCredential?.email)
                Auth.auth().signIn(with: credential) { result, error in
                    if error != nil, result == nil { return }
                    if let additionalUserInfo = result?.additionalUserInfo {
                        
                        if additionalUserInfo.isNewUser {
                            isModal = true
                        } else {
                            FetchFromFirestore().fetchUserInfoFromFirestore { user in
                                self.userModel.uid = user.id
                                self.userModel.nickname = user.nickname
                                self.userModel.email = user.email
                                self.userModel.activeRegion = user.activityRegion
                                self.userModel.birthPlace = user.birthPlace
                                self.userModel.educationalBackground = user.educationalBackground
                                self.userModel.work = user.work
                                self.userModel.height = user.height
                                self.userModel.weight = user.weight
                                self.userModel.bloodType = user.bloodType
                                self.userModel.liquor = user.liquor
                                self.userModel.cigarettes = user.cigarettes
                                self.userModel.purpose = user.purpose
                                self.userModel.datingExpenses = user.datingExpenses
                                self.userModel.birthDate = user.birthDate
                                self.userModel.gender = user.gender
                                self.userModel.profileImageURL = user.profileImageURL
                                self.userModel.subProfileImageURL = user.subProfileImageURLs
                                self.userModel.introduction = user.introduction
                                self.userModel.friendUids = user.friendUids
                                self.userModel.requestUids = user.requestUids
                                self.userModel.requestedUids = user.requestedUids
                                self.userModel.pairRequestUid = user.pairRequestUid
                                self.userModel.pairRequestedUids = user.pairRequestedUids
                                self.userModel.pairUid = user.pairUid
                                self.userModel.hobbies = user.hobbies
                                self.userModel.pairID = user.pairID
                                self.userModel.chatUnreadNum = user.chatUnreadNum
                                
                                if userModel.pairID != "" {
                                    FetchFromFirestore().fetchPairInfo(pairID: userModel.pairID) { pair in
                                        pairModel.pair = pair.adaptPairModel()
                                    }
                                } else {
                                    appState.notLoggedInUser = false
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
        .frame(width: UIScreen.main.bounds.width-32, height: 50)
        .sheet(isPresented: $isModal) {
            NickNameView()
                .interactiveDismissDisabled()
        }
    }
}

