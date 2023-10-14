//
//  CallBubbleView.swift
//  Merci
//
//  Created by Rio Nagasaki on 2023/10/10.
//

import SwiftUI

struct MyCallBubbleView: View {
    let message: ChatObservableModel
    var body: some View {
        HStack {
            Spacer()
            VStack {
                Image(systemName: "phone.circle.fill")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 32, height: 32)
                    .background(Color.white)
                    .clipShape(Circle())
                    .foregroundColor(.customBlack)
                
                Text("通話")
                    .foregroundColor(.customBlack)
                    .font(.system(size: 16, weight: .medium))
            }
            .frame(width: 120, height: 120)
            .background(Color.customRed.opacity(0.2))
            .cornerRadius(20)
        }
        .padding(.horizontal, 8)
    }
}


struct OtherUserCallBubbleView: View {
    let message: ChatObservableModel
    let user: UserObservableModel
    var body: some View {
        HStack(alignment:  .top){
            NavigationLink {
                UserProfileView(userId: message.fromUserUid, isFromHome: false)
            } label: {
                Image(user.user.profileImageURLString)
                    .resizable()
                    .frame(width: 18, height: 18)
                    .padding(.all, 6)
                    .background(Color.customLightGray)
                    .clipShape(Circle())
            }
            VStack(alignment: .leading){
                Text(message.fromUserNickname)
                    .font(.system(size: 8, weight: .bold))
                    .foregroundColor(.black)
                VStack {
                    
                    Image(systemName: "phone.circle.fill")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 32, height: 32)
                        .foregroundColor(.customBlack)
                    
                    Text("通話")
                        .foregroundColor(.customBlack)
                        .font(.system(size: 16, weight: .medium))
                }
                .frame(width: 120, height: 120)
                .background(Color.gray.opacity(0.2))
                .cornerRadius(20)
            }
            Spacer()
        }
        .padding(.horizontal, 16)
    }
}
