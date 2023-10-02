//
//  BlockingUserProfileBottomView.swift
//  Merci
//
//  Created by Rio Nagasaki on 2023/09/22.
//

import SwiftUI

struct BlockingUserProfileBottomView: View {
    @StateObject var viewModel = BlockingUserProfileBottomViewModel()
    @EnvironmentObject var userModel: UserObservableModel
    let user: UserObservableModel
    var body: some View {
        Button {
            viewModel.resolveBlock(requestingUser: userModel, requestedUser: user)
        } label: {
            Text("ブロックを解除する")
                .foregroundColor(.customRed)
                .frame(width: UIScreen.main.bounds.width/1.2, height: 40)
                .cornerRadius(20)
                .overlay {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.customRed, lineWidth: 1)
                }
        }

    }
}
