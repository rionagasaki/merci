//
//  OneHobbyView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/24.
//

import SwiftUI

struct OneHobbyView: View {
    let hobby: String
    let selected: Bool
    var body: some View {
        Text(hobby)
            .foregroundColor(selected ? .white: .customBlack.opacity(0.8))
            .font(.system(size: 14, weight: .bold))
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .background(selected ? .pink: .gray.opacity(0.1))
            .cornerRadius(20)
    }
}

struct OneHobbyView_Previews: PreviewProvider {
    static var previews: some View {
        OneHobbyView(hobby: "aa", selected: false)
    }
}
