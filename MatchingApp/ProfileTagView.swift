//
//  ProfileTagView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/26.
//

import SwiftUI

struct ProfileTagView: View {
    let tagName: String
    var body: some View {
        Text(tagName)
            .foregroundColor(.black)
            .fontWeight(.light)
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
            .background(Color.gray.opacity(0.1))
            .cornerRadius(20)
            .overlay {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(.gray.opacity(0.8), lineWidth: 1)
            }
    }
}

struct ProfileTagView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileTagView(tagName: "サッカー")
    }
}
