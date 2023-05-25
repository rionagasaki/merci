//
//  SelectPairCell.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/10.
//

import SwiftUI

struct SelectPairCell: View {
    let username: String
    var body: some View {
        HStack(spacing: .zero){
            Image("Person")
                .resizable()
                .frame(width: 50, height: 50)
                .clipShape(Circle())
            Text(username)
                .foregroundColor(.black.opacity(0.8))
                .font(.system(size: 16))
                .padding(.leading, 16)
            Spacer()
            Checkbox()
        }
        .padding(.horizontal, 16)
    }
}

struct SelectPairCell_Previews: PreviewProvider {
    static var previews: some View {
        SelectPairCell(username: "Rionjckdsakdssajfsakljkladsjfsldkajjfdskladkfkdasfakljklfjalkfjklsadfjskl")
    }
}
