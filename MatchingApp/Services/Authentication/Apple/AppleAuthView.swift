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
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var userModel: UserObservableModel
    @StateObject var viewModel = AppleAuthViewModel()
    @Environment(\.dismiss) var dismiss
    var body: some View {
        SignInWithAppleButton(.signIn){ request in
            viewModel.handleRequest(request: request)
        } onCompletion: { result in
            Task {
                await viewModel.handleResult(
                    result: result,
                    userModel: userModel,
                    appState: appState
                )
            }
        }
        .signInWithAppleButtonStyle(.black)
        .frame(width: UIScreen.main.bounds.width-32, height: 50)
        .cornerRadius(30)
    }
}


