//
//  ProfileHeaderTopView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/07/06.
//

import SwiftUI

struct ProfileHeaderTopView: View {
    var body: some View {
        HStack {
            Image(systemName: "person.2.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .foregroundColor(.white)
            VStack(alignment: .leading){
                Text("ペアを決めてアプリを始めよう！")
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .bold))
                Text("初めてのペア登録で100ポイントプレゼント！")
                    .foregroundColor(.white)
                    .font(.system(size: 14))
            }
            Spacer()
            Image(systemName: "chevron.forward")
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .foregroundColor(.white)
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 8)
        .background(Color.pink.opacity(0.7))
        .cornerRadius(10)
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .stroke(.pink, lineWidth: 2)
        }
        .padding(.horizontal, 16)
        
        
    }
}

struct ProfileHeaderTopView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileHeaderTopView()
    }
}
