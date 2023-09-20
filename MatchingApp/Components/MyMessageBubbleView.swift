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
