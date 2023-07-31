//
//  RegisterView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/01.
//

import SwiftUI
import AuthenticationServices

struct RegisterView: View {
    @Binding var isShow: Bool
    @Binding var alreadyHasAccount: Bool
    @Binding var alertText: String
    @StateObject private var viewModel = RegisterViewModel()
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack {
            VStack {
                AppleAuthView()
                GoogleRegisterView()
                EmailRegisterButton(isShow: $isShow)
            }
        }
    }
}
