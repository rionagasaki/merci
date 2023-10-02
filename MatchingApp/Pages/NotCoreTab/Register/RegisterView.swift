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
    @State var isWebView: Bool = false
    @State var webUrlString: String = ""
    @StateObject private var viewModel = RegisterViewModel()
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        VStack {
            VStack {
                AppleAuthView()
                GoogleRegisterView()
                VStack(alignment: .leading){
                    Text("登録前に、利用規約とプライバシーポリシーを確認してください。")
                        .foregroundColor(.customBlack)
                        .font(.system(size: 16, weight: .medium))
                    Button {
                        self.webUrlString = "https://bow-elm-3dc.notion.site/87888d609f734e0eb6d836ae091cd973"
                        self.isWebView = true
                    } label: {
                        Text("利用規約")
                            .foregroundColor(.customBlue)
                            .opacity(0.8)
                    }
                    Button {
                        self.webUrlString = "https://bow-elm-3dc.notion.site/23249233cc484fc390409a809b793985"
                        self.isWebView = true
                    } label: {
                        Text("プライバシーポリシー")
                            .foregroundColor(.customBlue)
                            .opacity(0.8)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 24)
            }
            .padding(.vertical, 16)
        }
        .sheet(isPresented: $isWebView){
            if let loadUrl = URL(string: webUrlString) {
                WebView(loadUrl: loadUrl)
            }
        }
    }
}
