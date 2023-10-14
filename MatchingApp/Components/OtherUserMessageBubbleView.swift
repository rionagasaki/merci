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
                    .frame(width: 18, height: 18)
                    .padding(.all, 6)
                    .background(Color.customLightGray)
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

struct OtherUserConcernMessageBubbleView: View {
    let message: ChatObservableModel
    let user: UserObservableModel
    var body: some View {
        VStack {
            HStack(alignment: .bottom){
                VStack {
                    HStack {
                        Text(message.concernKind)
                            .foregroundColor(.customBlack)
                            .font(.system(size: 16, weight: .medium))
                        
                        Image(message.concernKindImageName)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 24, height: 24)
                            .padding(.all, 8)
                            .background(Color.customLightGray)
                            .clipShape(Circle())
                    }
                    
                    Text(message.concernText)
                        .foregroundColor(.gray)
                        .font(.system(size: 12))
                    Divider()
                    Text(message.message)
                        .foregroundColor(.customBlack)
                    
                }
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .cornerRadius(20)
            }
            .padding(.horizontal, 8)
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

                VStack(alignment: .leading, spacing: 4){
                    Text(message.fromUserNickname)
                        .font(.system(size: 8, weight: .bold))
                        .foregroundColor(.black)
                    Text("\(user.user.nickname)さんがお悩みに回答しました。")
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
}

