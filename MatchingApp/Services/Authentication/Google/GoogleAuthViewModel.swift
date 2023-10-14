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

@MainActor
final class GoogleAuthViewModel: ObservableObject {
    private let userService = UserFirestoreService()
    @Published var cancellable = Set<AnyCancellable>()
    @Published var errorMessage: String = ""
    @Published var isErrorAlert: Bool = false
    @ObservedObject var tokenData = TokenData.shared
    
    func googleAuth(userModel: UserObservableModel, appState: AppState, isNewUser: Bool) async {
        guard let clientID:String = FirebaseApp.app()?.options.clientID else { return }
        let config:GIDConfiguration = GIDConfiguration(clientID: clientID)

        if let windowScene:UIWindowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene, let firstWindow:UIWindow = windowScene.windows.first, let rootViewController = firstWindow.rootViewController {
            GIDSignIn.sharedInstance.configuration = config
                do {
                    let result = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
                    let user = result.user
                    let idToken = user.idToken?.tokenString ?? ""
                    let accessToken = user.accessToken.tokenString
                    let profile = user.profile
                    let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: user.accessToken.tokenString)
                    
                    guard let profile = profile else { return }
                    
                    try await userService.checkAccountExists(email: profile.email , isNewUser: isNewUser)
                    
                    if isNewUser {
                        await self.login(credential: credential, userModel: userModel, appState: appState)
                    } else {
                        await self.register(credential: credential, appState: appState)
                    }
                    
                } catch let error as AppError {
                    self.errorMessage = error.errorMessage
                    self.isErrorAlert = true
                } catch {
                    self.errorMessage = error.localizedDescription
                    self.isErrorAlert = true
                }
        }
    }
    
    private func login(credential: AuthCredential, userModel:UserObservableModel, appState: AppState) async {
        do {
            let authResult = try await AuthenticationService.shared.signInWithGoogle(credential: credential)
            try await self.userService.updateUserInfo(currentUid: authResult.user.uid, key: "fcmToken", value: self.tokenData.token)
            userModel.user.uid = authResult.user.uid
        } catch let error as AppError {
            self.errorMessage = error.errorMessage
            self.isErrorAlert = true
        } catch {
            self.errorMessage = error.localizedDescription
            self.isErrorAlert = true
        }
    }
    
    private func register(credential: AuthCredential, appState: AppState) async {
        do {
            let result = try await AuthenticationService.shared.signInWithGoogle(credential: credential)
            let email = result.user.email ?? ""
            let uid = result.user.uid
            try await userService.registerUserEmailAndUid(email: email, uid: uid)
        } catch let error as AppError {
            self.errorMessage = error.errorMessage
            self.isErrorAlert = true
        } catch {
            self.errorMessage = error.localizedDescription
            self.isErrorAlert = true
        }
    }
}
