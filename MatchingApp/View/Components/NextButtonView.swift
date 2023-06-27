//
//  NextButtonView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/04.
//

import SwiftUI

struct NextButtonView: View {
    @Binding var isEnabled: Bool
    var body: some View {
        Image(systemName: "arrow.right")
            .resizable()
            .frame(width:20, height: 20)
            .padding()
            .background(isEnabled ? Color.customBlack: Color.gray.opacity(0.4))
            .foregroundColor(.white)
            .clipShape(Circle())
    }
}
