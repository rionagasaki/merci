//
//  SettingView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/04.
//
import SwiftUI
struct SettingView: View {
    
    @EnvironmentObject var appState: AppState
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel = SettingViewModel()
    
    var body: some View {
        
        List {
            Section(header: Text("アカウント設定")) {
                Button {
                    self.viewModel.webUrlString = "https://www.notion.so/merci-b6582adddfa346528d17bf0b76c5ec06"
                    self.viewModel.isWebView = true
                } label: {
                    SettingCellView(systemImageName: "questionmark.circle", text: "サービス内容")
                }

                
                NavigationLink {
                    BlockedUserListView()
                } label: {
                    SettingCellView(systemImageName: "person.fill.xmark", text: "ブロック中のユーザー")
                }
                
                NavigationLink {
                    HiddenChatUserListView()
                } label: {
                    SettingCellView(systemImageName: "eye.slash.fill", text: "非表示中のチャットルーム")
                }
                
                
                Button {
                    self.viewModel.webUrlString = "https://bow-elm-3dc.notion.site/87888d609f734e0eb6d836ae091cd973"
                    self.viewModel.isWebView = true
                } label: {
                    SettingCellView(systemImageName: "doc.text", text: "利用規約")
                }
                Button {
                    self.viewModel.webUrlString = "https://bow-elm-3dc.notion.site/23249233cc484fc390409a809b793985"
                    self.viewModel.isWebView = true
                } label: {
                    SettingCellView(systemImageName: "lock.shield", text: "プライバシポリシー")
                }
                NavigationLink {
                    AccountDeleteView()
                } label: {
                    SettingCellView(systemImageName: "person.fill.badge.minus", text: "アカウント削除")
                }
                Button {
                    self.viewModel.isSignOutAlert = true
                } label: {
                    SettingCellView(systemImageName: "person.badge.minus.fill", text: "サインアウト")
                }
                
            }
        }
        .navigationTitle("設定")
        .fullScreenCover(isPresented: $viewModel.isWebView){
            if let loadUrl = URL(string: viewModel.webUrlString) {
                WebView(loadUrl: loadUrl)
            }
        }
        .onReceive(viewModel.$isSuccess){
            if $0 {
                presentationMode.wrappedValue.dismiss()
            }
        }
        .alert(isPresented: $viewModel.isSignOutAlert){
            Alert(
                title: Text("ログアウト"),
                message: Text("一旦ログアウトしても、また遊びに来てね！続ける？"),
                primaryButton: .cancel(Text("キャンセル")),
                secondaryButton: .destructive(Text("ログアウト"), action: { Task { await viewModel.signOut() } })
            )
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
