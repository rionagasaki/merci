//
//  BannerView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/06/23.
//

import SwiftUI

struct BannerView: View {
    var body: some View {
        HStack {
            VStack {
                Text("マッチング率を大幅アップ")
                    .foregroundColor(.black)
                    .padding(.all,8)
                    .background(Color.yellow.opacity(0.5))
                    .font(.system(size: 13, weight: .bold))
                    .cornerRadius(10)
                Text("プロフィール写真のコツ")
                    .foregroundColor(.pink)
                    .font(.system(size: 16, weight: .bold))
            }
            .padding(.leading, 16)
            Spacer()
            Image("LadyProfile")
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .cornerRadius(10)
            
        }
        .padding(.all, 4)
        .frame(width: UIScreen.main.bounds.width-32, height: 90)
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .stroke(.yellow.opacity(0.5), lineWidth: 2)
        }
    }
}

struct BannerView_Previews: PreviewProvider {
    static var previews: some View {
        BannerView()
    }
}
