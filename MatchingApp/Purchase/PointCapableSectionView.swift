//
//  PointCapableSectionView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/06/25.
//

import SwiftUI

struct PointCapableSectionView: View {
    var body: some View {
        VStack {
            HStack {
                Text("1")
                    .foregroundColor(.white)
                    .frame(width: 25, height: 25)
                    .background(Color.pink.opacity(0.7))
                    .clipShape(Circle())
                Text("メッセージやり取りができます")
                    .foregroundColor(.customBlack)
                    .font(.system(size: 20, weight: .bold))
                
            }
            HStack(spacing: 32) {
                Image("Coin")
                    .resizable()
                    .frame(width: 80, height: 80)
                Image(systemName: "equal")
                    .resizable()
                    .frame(width: 30, height: 20)
                    .foregroundColor(.customBlack.opacity(0.5))
                Image(systemName: "ellipsis.message")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.customBlack)
                    .padding(.leading, 8)
            }
            Text("10ポイントで1グループとメッセージやり取りができます。")
                .foregroundColor(.customBlack)
        }
        .padding(.horizontal, 32)
        .padding(.vertical, 16)
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .stroke(.gray.opacity(0.8), lineWidth: 1)
                .padding(.horizontal, 16)
                .shadow(radius: 10)
        }
    }
}

struct PointCapableSectionView_Previews: PreviewProvider {
    static var previews: some View {
        PointCapableSectionView()
    }
}
