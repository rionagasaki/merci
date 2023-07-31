//
//  OtherUserMessageBubbleView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/06/05.
//

import SwiftUI
import SDWebImageSwiftUI

struct OtherUserMessageBubbleView: View {
    let messageInfo: ChatObservableModel
    var body: some View {
        HStack(alignment:  .top){
            WebImage(url: URL(string: messageInfo.sendUserProfileImageURL))
                .resizable()
                .frame(width: 30, height: 30)
                .clipShape(Circle())
            VStack(alignment: .leading, spacing: 4){
                Text(messageInfo.sendUserNickname)
                    .font(.system(size: 8, weight: .bold))
                    .foregroundColor(.black)
                Text(messageInfo.message)
                    .foregroundColor(.black)
                    .padding(.all, 8)
                    .background(Color.red.opacity(0.3))
                    .cornerRadius(10)
            }
            VStack {
                Spacer()
                Text(messageInfo.createdAt)
                    .foregroundColor(.gray.opacity(0.7))
                    .font(.system(size: 12, weight: .light))
            }
                
            Spacer()
        }
        .padding(.leading, 8)
    }
}

struct OtherUserMessageBubbleView_Previews: PreviewProvider {
    static var previews: some View {
        OtherUserMessageBubbleView(messageInfo: .init())
    }
}
