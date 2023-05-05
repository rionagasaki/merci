//
//  DismissButtonView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/05.
//

import SwiftUI

struct DismissButtonView: View {
    var body: some View {
        Image(systemName: "arrow.left")
            .resizable()
            .frame(width:20, height: 20)
            .padding()
            .background(Color.gray.opacity(0.6))
            .foregroundColor(.white)
            .clipShape(Circle())
    }
}

struct DismissButtonView_Previews: PreviewProvider {
    static var previews: some View {
        DismissButtonView()
    }
}
