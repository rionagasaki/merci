//
//  UserProfileView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/05.
//

import SwiftUI

struct UserProfileView: View {
    var body: some View {
        VStack {
            Image("Person")
                .resizable()
                .frame(width: 100, height: 100)
                .clipShape(Circle())
            Text("")
        }
    }
}

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView()
    }
}
