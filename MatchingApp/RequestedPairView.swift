//
//  RequestedPairView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/27.
//

import SwiftUI

struct RequestedPairView: View {
    @EnvironmentObject var userModel: UserObservableModel
    @Environment(\.dismiss) var dismiss
    
    // リクエストしているユーザーのユーザー情報。
    let userID: String
    let nickname: String
    let birthDate: String
    let activeRegion: String
    let profileImageURL: String
    let introduction: String
    
    var body: some View {
        VStack {
            ScrollView {
                Text("ペア招待が来ています")
                    .foregroundColor(.white)
                    .font(.system(size: 20))
                    .bold()
                    .frame(width: UIScreen.main.bounds.width-20, height: 60)
                    .background(Color.pink.opacity(0.7))
                    .cornerRadius(10)
                
                Image("Person")
                    .resizable()
                    .frame(width: UIScreen.main.bounds.width-60, height:UIScreen.main.bounds.width-60)
                    .scaledToFit()
                    .cornerRadius(10)
                    .padding(.top, 16)
                
                HStack {
                    Text("あや")
                    Text("24歳")
                    Text("東京")
                }
                .foregroundColor(.black.opacity(0.8))
                .font(.system(size: 25))
                .fontWeight(.light)
                .padding(.vertical, 8)
                
            }
            
            Spacer()
            Button {
                SetToFirestore.shared.updatePair(currentUser: userModel, requestedUid: userModel.requestedUids[0])
                dismiss()
            } label: {
                Text("受け入れる")
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width-40, height: 60)
                    .background(Color.customGreen)
                    .cornerRadius(10)
            }

        }
    }
}

