//
//  GoogleRegisterViewModel.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/07/07.
//

import SwiftUI
import Combine
import GoogleSignIn
import GoogleSignInSwift
import Firebase

class GoogleRegisterViewModel: ObservableObject {
    @Published var isModal: Bool = false
    @Published var alreadyHasAccountAlert = false
    @Published var alertText: String = ""
    let fetchFromFirestore = FetchFromFirestore()
    private var cancellable = Set<AnyCancellable>()
    
    func googleAuth() {
        guard let clientID:String = FirebaseApp.app()?.options.clientID else { return }
        let config:GIDConfiguration = GIDConfiguration(clientID: clientID)
        
        let windowScene:UIWindowScene? = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let rootViewController:UIViewController? = windowScene?.windows.first!.rootViewController!
        
        GIDSignIn.sharedInstance.configuration = config
        
        GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController!) { result, error in
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
            
            self.fetchFromFirestore.checkAccountExists(email: profile.email, isNewUser: true)
                .sink { completion in
                    switch completion {
                    case .finished:
                        let credential = GoogleAuthProvider.credential(withIDToken: idToken,accessToken: user.accessToken.tokenString)
                        self.register(credential: credential)
                    case .failure(let error):
                        self.alreadyHasAccountAlert = true
                        self.alertText = error.errorMessage
                    }
                } receiveValue: { _ in
                    print("Recieve Value")
                }
                .store(in: &self.cancellable)
        }
    }
    
    func register(credential: AuthCredential) {
        
        AuthenticationService.shared.signInWithGoogle(credential: credential)
            .sink { completion in
                switch completion {
                case .finished:
                    self.isModal = true
                case .failure(_):
                    print("サインアップエラー")
                }
            } receiveValue: { _ in
                print(" Recieve Value")
            }
            .store(in: &self.cancellable)
    }
}
