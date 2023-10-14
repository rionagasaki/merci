//
//  MyMessageBubbleView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/06/05.
//

import SwiftUI

struct MyMessageBubbleView: View {
    let message: ChatObservableModel
    var body: some View {
        HStack(alignment: .bottom){
            Spacer()
            Text(message.createdAt)
                .foregroundColor(.gray.opacity(0.7))
                .font(.system(size: 12, weight: .light))
            Text(message.message)
                .foregroundColor(.customBlack)
                .padding(.vertical, 8)
                .padding(.horizontal, 12)
                .background(Color.customRed.opacity(0.2))
                .cornerRadius(20)
        }
        .padding(.horizontal, 8)
    }
}

struct MyMessageBubbleView_Previews: PreviewProvider {
    static var previews: some View {
        MyMessageBubbleView(message: .init())
    }
}


struct MyConcernMessageBubbleView: View {
    let message: ChatObservableModel
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
                .background(Color.customGray.opacity(0.7))
                .cornerRadius(20)
            }
            .padding(.horizontal, 8)
            HStack(alignment: .bottom){
                Spacer()
                Text(message.createdAt)
                    .foregroundColor(.gray.opacity(0.7))
                    .font(.system(size: 12, weight: .light))
                Text("お悩みに返信しました。")
                    .foregroundColor(.customBlack)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 12)
                    .background(Color.customRed.opacity(0.2))
                    .cornerRadius(20)
            }
            .padding(.horizontal, 8)
        }
    }
}
