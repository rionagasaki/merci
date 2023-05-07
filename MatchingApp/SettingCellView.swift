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
            Divider()
            HStack {
                
                Image(systemName: systemImageName)
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.black)
                Text(text)
                    .fontWeight(.light)
                    .foregroundColor(.black)
                
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
