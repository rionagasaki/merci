//
//  CallMessageView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/08/29.
//

import SwiftUI

struct CallMessageView: View {
    let isFromUser: Bool
    @State var isJoinCall: Bool = false
    var body: some View {
        VStack {
            Image(systemName: "phone.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 40)
                .foregroundColor(.customBlack)
            Text(isFromUser ? "発信": "着信")
                .foregroundColor(.customBlack)
                .font(.system(size: 16, weight: .medium))
                .padding(.top, 8)
        }
        .frame(width: 128, height: 128)
        .background(Color.red.opacity(0.3))
        .cornerRadius(20)
        .actionSheet(isPresented: $isJoinCall){
            ActionSheet(title: Text("着信中です"))
        }
    }
}

struct CallMessageView_Previews: PreviewProvider {
    static var previews: some View {
        CallMessageView(isFromUser: true)
    }
}
