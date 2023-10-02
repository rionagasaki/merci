//
//  ProfileBottomResolveBlockButton.swift
//  Merci
//
//  Created by Rio Nagasaki on 2023/09/27.
//

import SwiftUI

struct ProfileBottomResolveBlockButton: View {
    @EnvironmentObject var fromUser: UserObservableModel
    let toUser: UserObservableModel
    @StateObject var viewModel = ProfileBottomResolveBottonViewModel()
    var body: some View {
        Button {
            viewModel.resolveBlock(userModel: fromUser, user: toUser)
        } label: {
            Text("ブロック解除")
                .foregroundColor(.customRed)
                .frame(width: (UIScreen.main.bounds.width/1.2)/1.2 , height: 40)
                .background(Color.white)
                .overlay {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.customRed, lineWidth: 1)
                }
                .padding(.top, 16)
        }
    }
}
