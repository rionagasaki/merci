//
//  CurrentUserProfileBottomView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/08/22.
//

import SwiftUI

struct CurrentUserProfileBottomView: View {
    @State var isShareModal: Bool = false
    var body: some View {
        HStack {
            NavigationLink {
                PairSettingView()
            } label: {
                HStack {
                    Text("ユーザーを探す")
                    Image(systemName: "plus")
                }
                .foregroundColor(.white)
                .font(.system(size: 14))
                .frame(width: (UIScreen.main.bounds.width/1.2)/1.2, height: 40)
                .background(Color.customBlack)
                .cornerRadius(20)
            }
            Button {
                self.isShareModal = true
            } label: {
                ZStack {
                    Circle()
                        .stroke(Color.customBlack, lineWidth: 1)
                        .frame(width: 40, height: 40)
                    
                    Image(systemName: "link")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 20, height: 20)
                        .foregroundColor(.customBlack)
                    
                }
            }
        }
        .padding(.vertical, 16)
        .halfModal(isPresented: $isShareModal) {
            SNSShareView()
        }
    }
}

struct CurrentUserProfileBottomView_Previews: PreviewProvider {
    static var previews: some View {
        CurrentUserProfileBottomView()
    }
}
