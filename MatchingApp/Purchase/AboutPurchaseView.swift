//
//  AboutPurchaseView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/06/25.
//

import SwiftUI

struct AboutPurchaseView: View {
    private let aboutPurchases = [
    "・有料サービスのお支払いを行うことにより、NiNiポイント利用規約に同意したとみなされます。",
    "・お支払いはApple ID決済での一括払いとなります。",
    "・お申込み後の全額返金および部分返金には対応しておりません。"
    ]
    
    
    var body: some View {
        VStack(alignment: .leading){
            Text("NiNiポイントでできること(男性会員)")
                .foregroundColor(.customBlack)
                .font(.system(size: 24, weight: .bold))
            
            
            
            Text("NiNiポイントの購入について")
                .foregroundColor(.customBlack)
                .font(.system(size: 24, weight: .bold))
            
            ForEach(aboutPurchases, id: \.self) { text in
                Text(text)
                    .foregroundColor(.customBlack)
                    .font(.system(size: 14, weight: .light))
            }
            
            Button {
                print("aaaa")
            } label: {
                Text("リストアする")
                    .foregroundColor(.pink.opacity(0.7))
                    .frame(width: UIScreen.main.bounds.width-36, height: 50)
                    .overlay {
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(.pink.opacity(0.7), lineWidth: 2)
                    }
            }

            
            
        }
        .padding(.horizontal, 16)
            
    }
}

struct AboutPurchaseView_Previews: PreviewProvider {
    static var previews: some View {
        AboutPurchaseView()
    }
}

