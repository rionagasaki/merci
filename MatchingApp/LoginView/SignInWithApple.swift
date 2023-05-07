//
//  SignInWithApple.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/08.
//

import SwiftUI
import CryptoKit
import AuthenticationServices

struct AppleAuthView: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var appState: AppState
    @State var isError: Bool = false
    var body: some View {
        VStack {
            SignInWithAppleButton(.continue) { request in
                request.requestedScopes = [.fullName, .email]
            } onCompletion: { result in
                switch result {
                case .success(let authResults):
                    switch authResults.credential {
                    case let appleIDCredential as ASAuthorizationAppleIDCredential:
                        appState.isLogin = true
                    default: print("ここでログイン処理を呼び出す。")
                        
                    }
                case .failure(let error):
                    print("Authorisation failed: \(error.localizedDescription)")
                }
            }
            .signInWithAppleButtonStyle(.black)
            .frame(width: 224, height: 40)
            
            SignInWithAppleButton(.signIn) { request in
                request.requestedScopes = [.fullName, .email]
            } onCompletion: { authResults in
                switch authResults {
                case .success(let authResult):
                    print("完了:\(authResult.credential)")
                    break
                case .failure(let error):
                    print("Error")
                    isError = true
                }
            }
            .signInWithAppleButtonStyle(.black)
            .frame(width: 224, height: 40)
        }
    }
}

