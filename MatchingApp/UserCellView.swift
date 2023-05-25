//
//  UserCellView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/06.
//

import SwiftUI

struct UserCellView: View {
    let username: String
    let userImageIconsUrl: String
    
    var body: some View {
        HStack {
            Image(userImageIconsUrl)
                .resizable()
                .frame(width: 60, height: 60)
                .clipShape(Circle())
            
            Text(username)
                .fontWeight(.light)
                .font(.system(size: 16))
                .foregroundColor(.black)
                .padding(.leading, 8)
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .foregroundColor(.gray)
        }
        .padding(.horizontal, 16)
    }
}

struct UserCellView_Previews: PreviewProvider {
    static var previews: some View {
        UserCellView(username: "Rio", userImageIconsUrl: "Person")
    }
}
