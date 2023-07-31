//
//  ProfileHeaderBanner.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/07/06.
//

import SwiftUI

struct ProfileHeaderBottom_2: View {
    @EnvironmentObject var userModel: UserObservableModel
    var body: some View {
        ZStack {
            Image("BannerBackgroundBlue")
                .resizable()
                .scaledToFill()
                .frame(width: 150, height: 70)
            Text("アプリの使い方は\nこちらから✨")
                .foregroundColor(.black)
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

struct ProfileHeaderBanner_Previews: PreviewProvider {
    static var previews: some View {
        ProfileHeaderBottom_2()
    }
}
