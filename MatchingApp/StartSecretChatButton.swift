//
//  StartSecretChatButton.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/08/19.
//

import SwiftUI

struct StartSecretChatButton: View {
    var body: some View {
        VStack {

            Button {
                
            } label: {
                VStack {
                    ZStack(alignment: .bottomTrailing){
                        ZStack(alignment: .center){
                            Circle()
                                .size(width: 60, height: 60)
                                .foregroundColor(.gray.opacity(0.1))
                            
                            Image(systemName: "message.fill")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                                .foregroundColor(.customBlack)
                        }
                        
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 16, height: 16)
                            .foregroundColor(.customBlack)
                        
                    }
                    .frame(width: 60, height: 60)
                    Text("こそこそ話")
                        .foregroundColor(.customBlack)
                        .font(.system(size: 12, weight: .medium))
                }
            }
        }
        .padding(.horizontal, 16)
    }
}

struct StartSecretChatButton_Previews: PreviewProvider {
    static var previews: some View {
        StartSecretChatButton()
    }
}
