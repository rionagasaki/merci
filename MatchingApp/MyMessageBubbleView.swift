//
//  MyMessageBubbleView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/06/05.
//

import SwiftUI
import SDWebImageSwiftUI

struct MyMessageBubbleView: View {
    let messageInfo: ChatObservableModel
    var body: some View {
        HStack(alignment: .bottom){
            Spacer()
            Text(messageInfo.createdAt)
                .foregroundColor(.gray.opacity(0.7))
                .font(.system(size: 12, weight: .light))
            Text(messageInfo.message)
                .foregroundColor(.black)
                .padding(.all, 8)
                .background(Color.red.opacity(0.3))
                .cornerRadius(10)
        }
        .padding(.horizontal, 8)
    }
}

struct MyMessageBubbleView_Previews: PreviewProvider {
    static var previews: some View {
        MyMessageBubbleView(messageInfo: .init())
    }
}
