//
//  PlacePanelView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/01.
//

import SwiftUI

struct PlacePanelView: View {
    var body: some View {
        HStack {
            ZStack {
                Image("Tokyo")
                    .resizable()
                    .frame(width: (UIScreen.main.bounds.width/2)-20, height:(UIScreen.main.bounds.width/2) )
                Text("東京")
                    .foregroundColor(.white)
                    .font(.system(size: 18))
                    .bold()
                    
            }
            .cornerRadius(20)
            Spacer()
            ZStack {
                Image("Osaka")
                    .resizable()
                    .frame(width: (UIScreen.main.bounds.width/2)-20, height:(UIScreen.main.bounds.width/2) )
                Text("大阪")
                    .foregroundColor(.white)
                    .font(.system(size: 18))
                    .bold()
            }
            .cornerRadius(20)
        }
        .padding(.horizontal, 16)
    }
}

struct Place_Previews: PreviewProvider {
    static var previews: some View {
        PlacePanelView()
    }
}
