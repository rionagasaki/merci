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
    private let userService = UserFirestoreService()
    @Published var cancellable = Set<AnyCancellable>()
    @Published var errorMessage: String = ""
    @Published var isErrorAlert: Bool = false
    @ObservedObject var tokenData = TokenData.shared
    
    func googleAuth(
        userModel: UserObservableModel,
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

                self.userService.checkAccountExists(email: profile.email, isNewUser: false)
                    .sink { completion in
                        switch completion {
                        case .finished:
                            let credential = GoogleAuthProvider.credential(withIDToken: idToken,accessToken: user.accessToken.tokenString)
                            self.login(
                                credential: credential,
                                userModel: userModel,
                                appState: appState
                            )
                        case .failure(let error):
                            self.isErrorAlert = true
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
        appState: AppState
    ) {
        
        AuthenticationService.shared.signInWithGoogle(credential: credential)
            .flatMap { authResult in
                userModel.user.uid = authResult.user.uid
                return self.userService.updateUserInfo(currentUid: authResult.user.uid, key: "fcmToken", value: self.tokenData.token)
            }
            .sink { completion in
                switch completion {
                case .finished:
                    print("successfully login")
                case .failure(let error):
                    self.isErrorAlert = true
                    self.errorMessage = error.errorMessage
                }
            } receiveValue: { _ in }
            .store(in: &cancellable)
    }
}
