//
//  NoSendGoodsView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/06/02.
//

import SwiftUI

struct NoSendGoodsView: View {
    let text: String
    var body: some View {
        VStack {
            Image(systemName: "magnifyingglass")
                .resizable()
                .frame(width: 70, height: 70)
                .foregroundColor(.gray)
                .padding(.all, 32)
                .background(Color.gray.opacity(0.1))
                .clipShape(Circle())
            Text(text)
                .foregroundColor(.gray.opacity(0.8))
                .padding(.top, 16)
        }
    }
}

struct NoSendGoodsView_Previews: PreviewProvider {
    static var previews: some View {
        NoSendGoodsView(text: "ここにテキストテキスト")
    }
}
