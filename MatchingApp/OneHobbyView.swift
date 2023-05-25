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
            .foregroundColor(.black)
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
            .background(Color.white)
            .cornerRadius(20)
            .overlay {
                RoundedRectangle(cornerRadius: 20)
                    .stroke(selected ? .red: .gray.opacity(0.8), lineWidth: 1)
            }
    }
}

struct OneHobbyView_Previews: PreviewProvider {
    static var previews: some View {
        OneHobbyView(hobby: "aa", selected: false)
    }
}
