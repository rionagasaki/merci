//
//  NotLoginProfileView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/21.
//

import SwiftUI

struct NotLoginProfileView: View {
    @StateObject var viewModel = NotLoginViewModel()
    var body: some View {
        ScrollView {
            VStack {
                Text("プロフィールはログイン済みユーザーにのみに表示されます。")
                    .bold()
                    .foregroundColor(.customBlack)
                    .font(.system(size: 20))
                    
                Image("Profile")
                    .resizable()
                    .frame(width: 250, height: 250)
                Button {
                    viewModel.isModal = true
                } label: {
                    Text("ログインする or アカウント新規作成")
                        .foregroundColor(.white)
                        .font(.system(size: 16))
                        .bold()
                        .frame(width: UIScreen.main.bounds.width-60, height: 60)
                        .background(Color.customBlack)
                        .cornerRadius(10)
                }
                .padding(.top, 16)
            }
            .padding(.top, 56)
            .padding(.horizontal, 16)
        }
    }
}

struct NotLoginProfileView_Previews: PreviewProvider {
    static var previews: some View {
        NotLoginProfileView()
    }
}
