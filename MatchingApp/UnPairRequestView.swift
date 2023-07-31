//
//  UnPairRequestView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/07/23.
//

import SwiftUI
import SDWebImageSwiftUI

struct UnPairRequestView: View {
    let requestedUser: UserObservableModel
    var body: some View {
        VStack {
            Text("新しくペアを組むには、\(requestedUser.user.nickname)さんとペアを解除する必要があります")
                .foregroundColor(.customBlack)
                .font(.system(size: 20, weight: .bold))
                .frame(width: UIScreen.main.bounds.width-32)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 32)
            
            WebImage(url: URL(string: requestedUser.user.profileImageURL))
                .resizable()
                .scaledToFit()
                .frame(width: 120, height: 120)
                .cornerRadius(10)
                .padding(.top, 32)
            Text(requestedUser.user.nickname)
                .foregroundColor(.customBlack)
                .font(.system(size: 20, weight: .bold))
                .padding(.top, 8)
            
            if let age = CalculateAge.calculateAge(from: requestedUser.user.birthDate) {
                Text("\(age)歳・\(requestedUser.user.activeRegion)")
                    .foregroundColor(.customBlack)
                    .font(.system(size: 16))
            }
            
            Spacer()
            
            Button {
                print("ペアを解除する")
            } label: {
                Text("ペアを解除する")
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .bold))
            }
            .frame(width: UIScreen.main.bounds.width-32, height: 50)
            .background(Color.customRed)
            .cornerRadius(30)
        }
    }
}

