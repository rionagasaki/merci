//
//  PointHistoryView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/07/09.
//

import SwiftUI

struct PointHistoryView: View {
    var body: some View {
        VStack {
            Text("ポイントの内訳")
                .foregroundColor(.pink)
                .font(.system(size: 14, weight: .bold))
            LazyVGrid(columns: [.init()]) {
                HStack {
                    Text("購入ポイント残高")
                    Divider()
                    Label {
                        Text("0pt")
                    } icon: {
                        Image("Coin")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                    }
                }
                Divider()
                HStack {
                    Text("付与ポイント残高")
                    Divider()
                    Label {
                        Text("0pt")
                    } icon: {
                        Image("Coin")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 20, height: 20)
                    }
                }
            }
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.gray, lineWidth: 2)
            }
        }
        .navigationTitle("ポイント履歴")
    }
}

struct PointHistoryView_Previews: PreviewProvider {
    static var previews: some View {
        PointHistoryView()
    }
}
