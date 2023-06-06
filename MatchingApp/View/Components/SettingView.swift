//
//  SettingView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/04.
//
import SwiftUI
struct SettingView: View {
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "gearshape.fill")
                Text("設定")
            }
            .fontWeight(.heavy)
            .font(.system(size: 20))
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

            Divider()
        }
    }
}
struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
