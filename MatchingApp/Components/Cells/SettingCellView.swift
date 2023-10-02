//
//  SettingCellView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/05.
//

import SwiftUI

struct SettingCellView: View {
    let systemImageName: String
    let text: String
    var body: some View {
        VStack {
            HStack {
                Image(systemName: systemImageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 16, height: 16)
                    .foregroundColor(.customBlack)
                Text(text)
                    .foregroundColor(.customBlack)
                Spacer()
            }
            .padding(.vertical, 8)
           
        }
    }
}

struct SettingCellView_Previews: PreviewProvider {
    static var previews: some View {
        SettingCellView(systemImageName: "plus", text: "退会する")
    }
}
