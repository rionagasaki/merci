//
//  GoogleAuthViewModel.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/07/03.
//
import SwiftUI
import Combine
import GoogleSignIn
import GoogleSignInSwift
import Firebase

class GoogleAuthViewModel: ObservableObject {
    let fetchFromFirestore = FetchFromFirestore()
    let setToFirestore = SetToFirestore()
    @Published var isInitialLoadingFailed: Bool = false
    @Published var cancellable = Set<AnyCancellable>()
    @Published var errorMessage: String = ""
    @Published var isFailedAlert: Bool = false
    @ObservedObject var tokenData = TokenData.shared
    
    func googleAuth(
        userModel: UserObservableModel,
        pairModel: PairObservableModel,
        appState: AppState
    ){
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
                
                guard let profile = user.profile else { return }

                self.fetchFromFirestore.checkAccountExists(email: profile.email, isNewUser: false)
                    .sink { completion in
                        switch completion {
                        case .finished:
                            let credential = GoogleAuthProvider.credential(withIDToken: idToken,accessToken: user.accessToken.tokenString)
                            self.login(
                                credential: credential,
                                userModel: userModel,
                                pairModel: pairModel,
                                appState: appState
                            )
                        case .failure(let error):
                            self.isFailedAlert = true
                            self.errorMessage = error.errorMessage
                        }
                    } receiveValue: { _ in
                        print("Recieve Value")
                    }
                    .store(in: &self.cancellable)
            }
        }
    }
    
    private func login(
        credential: AuthCredential,
        userModel:UserObservableModel,
        pairModel: PairObservableModel,
        appState: AppState
    ) {
        
        AuthenticationService.shared.signInWithGoogle(credential: credential)
            .flatMap { authResult in
                userModel.user.uid = authResult.user.uid
                return self.setToFirestore.userFcmTokenUpdate(uid: authResult.user.uid, token: self.tokenData.token)
            }
            .flatMap { _ -> AnyPublisher<User, AppError> in
                return self.fetchFromFirestore.monitorUserUpdates(uid: userModel.user.uid)
            }
            .flatMap { user -> AnyPublisher<Pair, AppError> in
                userModel.user = user.adaptUserObservableModel()
                if userModel.user.unreadMessageCount.values.contains(where: { $0 > 0 }) {
                    appState.messageListNotification = true
                }
                if userModel.user.pairID.isEmpty {
                    appState.messageListViewInit = true
                    appState.notLoggedInUser = false
                    return Empty(completeImmediately: true).eraseToAnyPublisher()
                } else {
                    return self.fetchFromFirestore.monitorPairInfoUpdate(pairID: user.pairID)
                }
            }
            .flatMap { pair -> AnyPublisher<User?, AppError> in
                return self.fetchFromFirestore.fetchUserInfoFromFirestoreByUserID(uid: userModel.user.pairID)
            }
            .sink { completion in
                switch completion {
                case .finished:
                    print("this is no called because of snapshot listener.")
                case .failure(let error):
                    self.isFailedAlert = true
                    self.errorMessage = error.errorMessage
                }
            } receiveValue: { user in
                if let user = user {
                    appState.pairUserModel.user = user.adaptUserObservableModel()
                    appState.messageListViewInit = true
                    appState.notLoggedInUser = false
                }
            }
            .store(in: &cancellable)
    }
}
