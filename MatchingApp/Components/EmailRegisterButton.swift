//
//  EmailRegisterButton.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/06/16.
//

import SwiftUI

struct EmailRegisterButton: View {
    @Binding var isShow: Bool
    var body: some View {
        
        Button {
            withAnimation {
                isShow = true
            }
        } label: {
            HStack {
                Image(systemName: "envelope")
                    .resizable()
                    .frame(width: 17, height: 15)
                    .scaledToFit()
                Text("メールアドレスで登録")
                    .foregroundColor(.black)
                    .font(.system(size: 18, weight: .bold))
            }
            .frame(width: UIScreen.main.bounds.width-32, height: 50)
            .background(Color.white)
            .cornerRadius(30)
            .overlay {
                RoundedRectangle(cornerRadius: 30)
                    .stroke(.black,lineWidth: 1)
            }
            .padding(.top, 8)
        }
    }
}

