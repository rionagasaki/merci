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
            Text("🚶アカウント削除")
                .fontWeight(.bold)
                .font(.system(size: 28))
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
            VStack {
                Text("アカウント削除について")
                    .padding(16)
                    .font(.system(size: 24))
                Text("アカウント削除すると、全てのアカウントデータに加えて、アプリケーション内のメッセージやその履歴などの全ての情報が削除されます。\nなお、一度アカウント削除すると、アカウントの復旧はできなくなります。")
                    .padding(.horizontal, 16)
                    .padding(.bottom, 16)
                    

                Button {
                    print("aaa")
                } label: {
                    Text("アカウントを削除する")
                        .foregroundColor(.white)
                        .font(.system(size: 16))
                        .bold()
                        .frame(width: UIScreen.main.bounds.width - 40,height: 56)
                        .background(Color.red.opacity(0.8))
                        .cornerRadius(20)
                        .foregroundColor(.black)
                }
            }
            .padding(.bottom, 16)
            .background(.white)
        }.background(.ultraThinMaterial)
    }
}

struct AccountDeleteView_Previews: PreviewProvider {
    static var previews: some View {
        AccountDeleteView()
    }
}
