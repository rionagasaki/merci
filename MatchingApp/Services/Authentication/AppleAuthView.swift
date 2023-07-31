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
import Combine

struct AppleAuthView: View {
    @State var currentNonce: String?
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var userModel: UserObservableModel
    @EnvironmentObject var pairModel: PairObservableModel
    @State var isModal: Bool = false
    @State var isRequieredOnboarding: Bool = false
    @ObservedObject var tokenData = TokenData.shared
    let fetchFromFirestore = FetchFromFirestore()
    let setToFirestore = SetToFirestore()
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
    @State var isInitialLoadingFailed: Bool = false
    @State var cancellable = Set<AnyCancellable>()
    
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
                
                AuthenticationService.shared.signInWithApple(credential: credential)
                    .flatMap { authResult -> AnyPublisher<Void, AppError> in
                        guard let user = authResult.additionalUserInfo else {
                            return Empty(completeImmediately: true).eraseToAnyPublisher()
                        }
                        if user.isNewUser {
                            isModal = true
                            return Empty(completeImmediately: true).eraseToAnyPublisher()
                        }
                        userModel.user.uid = authResult.user.uid
                        return setToFirestore.userFcmTokenUpdate(uid: userModel.user.uid, token: tokenData.token)
                    }
                    .flatMap { _ -> AnyPublisher<User, AppError> in
                        return fetchFromFirestore.monitorUserUpdates(uid: userModel.user.uid)
                    }
                    .flatMap { user -> AnyPublisher<Pair, AppError> in
                        self.userModel.user = user.adaptUserObservableModel()
                        if userModel.user.unreadMessageCount.values.contains(where: { $0 > 0 }) {
                            appState.messageListNotification = true
                        }
                        if userModel.user.pairID.isEmpty {
                            appState.messageListViewInit = true
                            appState.notLoggedInUser = false
                            appState.isLoading = false
                            return Empty(completeImmediately: true).eraseToAnyPublisher()
                        } else {
                            return fetchFromFirestore.monitorPairInfoUpdate(pairID: user.pairID)
                        }
                    }
                    .flatMap { pair -> AnyPublisher<User?, AppError> in
                        return fetchFromFirestore.fetchUserInfoFromFirestoreByUserID(uid: userModel.user.pairUid)
                    }
                    .sink { completion in
                        switch completion {
                        case .finished:
                            print("ここはlistenがキャンセルされたら呼ばれる")
                        case .failure(_):
                            isInitialLoadingFailed = true
                        }
                    } receiveValue: { user in
                        appState.messageListViewInit = true
                        appState.notLoggedInUser = false
                        appState.isLoading = false
                        if let user = user {
                            appState.pairUserModel.user = user.adaptUserObservableModel()
                        }
                    }
                    .store(in: &cancellable)
            case .failure(let error):
                print("Authentication failed: \(error.localizedDescription)")
                break
            }
        }
        .signInWithAppleButtonStyle(.black)
        .frame(width: UIScreen.main.bounds.width-32, height: 50)
        .fullScreenCover(isPresented: $isModal) {
            NickNameView()
            
        }
    }
}
