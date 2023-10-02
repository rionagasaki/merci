//
//  UserListCellView.swift
//  Merci
//
//  Created by Rio Nagasaki on 2023/09/23.
//

import SwiftUI

struct UserListCellView: View {
    let user: UserObservableModel
    var body: some View {
        HStack {
            Image(user.user.profileImageURLString)
                .resizable()
                .scaledToFill()
                .frame(width: 48, height: 48)
                .padding(.all, 16)
                .background(Color.gray.opacity(0.1))
                .clipShape(Circle())
            
            Text(user.user.nickname)
                .foregroundColor(.customBlack)
                .font(.system(size: 20, weight: .medium))
                .padding(.leading, 16)
            Spacer()
        }
        .padding(.horizontal, 16)
    }
}
