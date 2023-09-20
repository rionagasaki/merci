//
//  OtherUserMessageBubbleView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/06/05.
//

import SwiftUI

struct OtherUserMessageBubbleView: View {
    let message: ChatObservableModel
    let user: UserObservableModel
    var body: some View {
        HStack(alignment:  .top){
            NavigationLink {
                UserProfileView(userId: message.fromUserUid, isFromHome: false)
            } label: {
                Image(user.user.profileImageURLString)
                    .resizable()
                    .frame(width: 30, height: 30)
                    .background(Color.gray.opacity(0.1))
                    .clipShape(Circle())
            }

            VStack(alignment: .leading, spacing: 4){
                Text(message.fromUserNickname)
                    .font(.system(size: 8, weight: .bold))
                    .foregroundColor(.black)
                Text(message.message)
                    .foregroundColor(.customBlack)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .background(Color.gray.opacity(0.2))
                    .cornerRadius(20)
            }
            VStack {
                Spacer()
                Text(message.createdAt)
                    .foregroundColor(.gray.opacity(0.7))
                    .font(.system(size: 12, weight: .light))
            }
                
            Spacer()
        }
        .padding(.leading, 8)
    }
}
