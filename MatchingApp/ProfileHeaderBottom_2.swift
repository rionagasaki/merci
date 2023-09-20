//
//  ProfileHeaderBanner.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/07/06.
//

import SwiftUI

struct ProfileHeaderBottom: View {
    @EnvironmentObject var userModel: UserObservableModel
    let imageName: String
    let text: String
    let textColor: Color
    let action: ()->Void
    var body: some View {
        Button {
            action()
        } label: {
            ZStack {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: (UIScreen.main.bounds.width/2)-16, height: 70)
                Text(text)
                    .foregroundColor(textColor)
                    .multilineTextAlignment(.center)
                    .font(.system(size: 15, weight: .bold))
            }
            .overlay {
                RoundedRectangle(cornerRadius: 10)
                    .stroke(.gray.opacity(0.6), lineWidth: 1)
            }
            .cornerRadius(10)
        }
    }
}

