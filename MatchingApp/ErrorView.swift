//
//  ErrorView.swift
//  Merci
//
//  Created by Rio Nagasaki on 2023/09/17.
//

import SwiftUI

struct ErrorView: View {
    var body: some View {
        VStack {
            Image("Error")
                .resizable()
                .scaledToFill()
                .frame(
                    width: UIScreen.main.bounds.width-32,
                    height: UIScreen.main.bounds.width-32
                )
            Text("申し訳ありません。このページは現在開けません。")
                .foregroundColor(.customBlack)
                .font(.system(size: 24, weight: .medium))
        }
    }
}

struct ErrorView_Previews: PreviewProvider {
    static var previews: some View {
        ErrorView()
    }
}
