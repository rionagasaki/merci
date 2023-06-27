//
//  RequestCellView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/06/21.
//

import SwiftUI
import SDWebImageSwiftUI

struct RequestCellView: View {
    let user: UserObservableModel
    @EnvironmentObject var userModel: UserObservableModel
    var body: some View {
        HStack {
            WebImage(url: URL(string: user.profileImageURL))
                .resizable()
                .frame(width: 70, height: 70)
                .clipShape(Circle())
            VStack(alignment: .leading){
                HStack {
                    Text(user.nickname)
                        .font(.system(size: 20, weight: .bold))
                    if let age = CalculateAge().calculateAge(from: user.birthDate) {
                        Text("\(age)歳・\(user.activeRegion)")
                            .font(.system(size: 16, weight: .light))
                    }
                }
                
                Button {
                    SetToFirestore.shared.updateFriend(currentUser: userModel, requestedUid: user.uid)
                } label: {
                    Text("承認する")
                        .foregroundColor(.white)
                        .frame(width: UIScreen.main.bounds.width-100, height: 40)
                        .background(Color.pink.opacity(0.7))
                        .cornerRadius(20)
                }

            }
        }
    }
}

