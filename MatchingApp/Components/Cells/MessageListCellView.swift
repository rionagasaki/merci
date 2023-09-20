//
//  SendGoodsListCellView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/06/02.
//

import SwiftUI
import SDWebImageSwiftUI

struct MessageListCellView: View {
    @EnvironmentObject var userModel: UserObservableModel
    let chatmate: UserObservableModel
    var body: some View {
        
        HStack(alignment: .top){
            Image(chatmate.user.profileImageURLString)
                .resizable()
                .scaledToFill()
                .frame(width: 40, height: 40)
                .padding(.all, 8)
                .background(Color.gray.opacity(0.1))
                .clipShape(Circle())
            
            VStack(alignment: .leading){
                Text(chatmate.user.nickname)
                    .foregroundColor(.customBlack)
                    .font(.system(size: 18, weight: .bold))
                if let chatRoomId = userModel.user.chatmateMapping[chatmate.user.uid],
                   let lastMessage = userModel.user.chatLastMessageMapping[chatRoomId]
                {
                    Text(lastMessage)
                        .foregroundColor(.gray)
                        .font(.system(size: 16))
                        .padding(.leading, 4)
                        .lineLimit(2)
                }
            }
            Spacer()
            if let chatRoomId = userModel.user.chatmateMapping[chatmate.user.uid],
               let lastMessageDateString = userModel.user.chatLastMessageTimestampString[chatRoomId]
            {
                if let unreadMessageCount = userModel.user.unreadMessageCount[chatRoomId], unreadMessageCount != 0 {
                    VStack(spacing: .zero){
                        Text(lastMessageDateString)
                            .foregroundColor(.gray.opacity(0.5))
                            .font(.system(size: 14, weight: .light))
                            .padding(.top, 4)
                        Text("\(unreadMessageCount)")
                            .foregroundColor(.white)
                            .font(.system(size: 14))
                            .padding(.all, 8)
                            .background(Color.customRed)
                            .clipShape(Circle())
                            .padding(.top, 2)
                    }
                } else {
                    Text(lastMessageDateString)
                        .foregroundColor(.gray.opacity(0.5))
                        .font(.system(size: 14, weight: .light))
                        .padding(.top, 4)
                }
            } else {
                Text("時間がない")
            }
        }
    }
}
