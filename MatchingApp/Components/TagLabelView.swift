//
//  ProfileTagView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/26.
//

import SwiftUI

struct TagLabelView: View {
    let tagName: String
    var body: some View {
        Text(tagName)
            .foregroundColor(.customBlack.opacity(0.8))
            .font(.system(size: 14, weight: .bold))
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(20)
    }
}

struct ProfileTagView_Previews: PreviewProvider {
    static var previews: some View {
        TagLabelView(tagName: "サッカー")
    }
}
