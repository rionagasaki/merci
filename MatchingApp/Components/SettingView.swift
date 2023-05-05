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
            
            SettingCellView(systemImageName: "person.fill.badge.minus", text: "サービス内容")
            SettingCellView(systemImageName: "person.fill.badge.minus", text: "利用規約")
            SettingCellView(systemImageName: "person.fill.badge.minus", text: "プライバシポリシー")
            SettingCellView(systemImageName: "person.fill.badge.minus", text: "オープンソースライブラリ")
            SettingCellView(systemImageName: "person.fill.badge.minus", text: "アカウント削除")
           Divider()
            
        }
    }
}

struct SettingView_Previews: PreviewProvider {
    static var previews: some View {
        SettingView()
    }
}
