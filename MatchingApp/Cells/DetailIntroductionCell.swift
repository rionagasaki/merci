//
//  DetailIntroductionCell.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/06.
//

import SwiftUI

struct DetailIntroductionCell: View {
    let title: String
    let introductionText: String
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(title)
                    .foregroundColor(.gray.opacity(0.8))
                    .font(.system(size: 14))
                
                    .padding(.vertical, 8)
                Text(introductionText)
                    .fontWeight(.light)
                    .font(.system(size: 16))
                    .foregroundColor(.black)
                    .padding(.bottom, 8)
            }
            
            Spacer()
            Image(systemName: "chevron.right")
                .resizable()
                .scaledToFit()
                .foregroundColor(.gray.opacity(0.8))
                .frame(width: 15, height: 15)
        }
        .padding(.horizontal, 16)
    }
}

struct DetailIntroductionCell_Previews: PreviewProvider {
    static var previews: some View {
        DetailIntroductionCell(title: "学校", introductionText: "東京大学")
    }
}
