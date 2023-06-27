//
//  SettingView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/04.
//
import SwiftUI
struct SettingView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("アカウント設定")) {
                    NavigationLink {
                        ServiceContentView()

                    } label: {
                        SettingCellView(systemImageName: "questionmark.circle", text: "サービス内容")
                    }
                    NavigationLink {
                        UsagePolicyView()
                    } label: {
                        SettingCellView(systemImageName: "doc.text", text: "利用規約")
                    }
                    NavigationLink {
                        PrivacyPolicyView()
                    } label: {
                        SettingCellView(systemImageName: "lock.shield", text: "プライバシポリシー")
                    }
                    NavigationLink {
                        OpenSourceLibraryView()
                    } label: {
                        SettingCellView(systemImageName: "person.fill.badge.minus", text: "オープンソースライブラリ")
                    }
                    NavigationLink {
                        AccountDeleteView()
                    } label: {
                        SettingCellView(systemImageName: "person.fill.badge.minus", text: "アカウント削除")
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .foregroundColor(.customBlack)
                    }

                }
            }
            .navigationTitle("⚙️各種設定")
        }
    }
}
struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
