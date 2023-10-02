//
//  OnlineUser.swift
//  Merci
//
//  Created by Rio Nagasaki on 2023/09/28.
//

import SwiftUI

struct OnlineUser: View {
    let user: UserObservableModel
    var body: some View {
        VStack {
            VStack {
                ZStack(alignment: .bottomTrailing){
                    Image(user.user.profileImageURLString)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 48, height: 48)
                        .padding(.all, 6)
                        .background(Color.gray.opacity(0.1))
                        .clipShape(Circle())
                    
                    ZStack {
                        Circle()
                            .frame(width: 16, height: 16)
                            .foregroundColor(.white)
                        
                        Circle()
                            .frame(width: 12, height: 12)
                            .foregroundColor(.green.opacity(0.8))
                    }
                }
            }
        }
    }
}
