//
//  PairAddView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/06/15.
//

import SwiftUI

struct PairAddView: View {
    var body: some View {
        HStack(alignment: .top){
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 120, height: 120)
                    .foregroundColor(.gray.opacity(0.2))
                    .overlay {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(.gray.opacity(0.7), lineWidth: 0.5)
                    }
                Image(systemName: "plus")
                    .resizable()
                    .frame(width: 30, height:30)
                    .foregroundColor(.customBlack.opacity(0.7))
            }
            VStack(alignment: .leading, spacing: .zero){
                 Text("ペア追加")
                     .bold()
                     .font(.system(size: 18))
                     .padding(.top, 16)
                
                 Text("新しい友達を追加して、お出かけしよう！")
                    .font(.system(size: 16))
                    .padding(.top, 4)
            }
            .foregroundColor(.customBlack)
        }
        .padding(.horizontal, 16)
    }
}

struct PairAddView_Previews: PreviewProvider {
    static var previews: some View {
        PairAddView()
    }
}
