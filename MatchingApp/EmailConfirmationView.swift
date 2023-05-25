//
//  EmailConfirmationView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/19.
//

import SwiftUI

struct EmailConfirmationView: View {
    @StateObject var viewModel: RegisterViewModel
    var body: some View {
        VStack {
            Text("メールアドレスの認証を行います。")
                .fontWeight(.light)
                .font(.system(size: 15))
                .padding(.top, 16)
            
            TextField("", text: $viewModel.verificationCode , prompt: Text("認証コード(6桁)"))
                .padding(.leading, 10)
                .frame(height: 38)
                .overlay(RoundedRectangle(cornerRadius: 3)
                    .stroke(Color.customLightGray, lineWidth: 2))
                .padding(.horizontal, 16)
                .padding(.top, 56)
            Button {
                Task {
                    
                }
            } label: {
                Text("認証する")
                    .frame(width: UIScreen.main.bounds.width-60, height: 60)
                    .background(.yellow)
            }
        }
    }
}
