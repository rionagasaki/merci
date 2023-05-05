//
//  NextButtonView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/04.
//

import SwiftUI

struct NextButtonView: View {
    var body: some View {
        Image(systemName: "arrow.right")
            .resizable()
            .frame(width:20, height: 20)
            .padding()
            .background(Color.gray.opacity(0.6))
            .foregroundColor(.white)
            .clipShape(Circle())
    }
}

struct NextButtonView_Previews: PreviewProvider {
    static var previews: some View {
        NextButtonView()
    }
}
