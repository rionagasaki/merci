//
//  AccountDeleteView.swift
//  MatchingApp
//
//  Created by 荒木太一 on 2023/05/07.
//
import SwiftUI

struct AccountDeleteView: View {
    var body: some View {
        ScrollView {
            VStack {
                Text("🚶アカウント削除")
                    .fontWeight(.bold)
                    .font(.system(size: 28))
                    .padding(16)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("アカウント削除について")
                    .padding(16)
                    .font(.system(size: 24))
                Text("アカウント削除すると、全てのアカウントデータに加えて、アプリケーション内のメッセージやその履歴などの全ての情報が削除されます。\nなお、一度アカウント削除すると、アカウントの復旧はできなくなります。")
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                    .fontWeight(.light)

                Button {
                    print("aaa")
                } label: {
                    Text("アカウントを削除する")
                        .padding(.horizontal, 88)
                        .padding(.vertical, 12)
                        .background(Color.yellow)
                        .cornerRadius(12)
                        .foregroundColor(.black)
                }
            }
        }
    }
}

struct AccountDeleteView_Previews: PreviewProvider {
    static var previews: some View {
        AccountDeleteView()
    }
}
