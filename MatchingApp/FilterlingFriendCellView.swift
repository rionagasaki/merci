//
//  FilterlingFriendCellView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/06/27.
//

import SwiftUI
import SDWebImageSwiftUI

struct FilterlingFriendView: View {
    let userModel: UserObservableModel
    @StateObject var viewModel: MessageListViewModel
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Text("ペアを選択して、チャットを確認できます。")
                .foregroundColor(.customBlack)
                .font(.system(size: 20, weight: .bold))
                .frame(width: UIScreen.main.bounds.width-32)
                .lineLimit(nil)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.top, 32)
            ForEach(viewModel.chatPartnerUser){ chatPartner in
                Button {
                    viewModel.selectedChatPartnerUid =
                    viewModel.selectedChatPartnerUid.isEmpty ?
                    chatPartner.user.uid:
                    ""
                } label: {
                    HStack {
                        WebImage(url: URL(string: chatPartner.user.profileImageURL))
                            .resizable()
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                        Text(chatPartner.user.nickname)
                            .foregroundColor(.customBlack)
                            .font(.system(size: 22, weight: .bold))
                        Spacer()
                    }
                }
                .padding(.horizontal, 8)
            }
            Spacer()
            Button {
                viewModel.changePairAndFetchMessageRooms(userModel: userModel, selectedChatPartnerUid: viewModel.selectedChatPartnerUid)
            } label: {
                Text("選択する")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: UIScreen.main.bounds.width-32, height: 50)
                    .background(viewModel.selectedChatPartnerUid.isEmpty ? .gray: .customRed)
                    .disabled(viewModel.selectedChatPartnerUid.isEmpty)
                    .cornerRadius(30)
            }

        }
        .padding(.horizontal, 16)
        .onReceive(viewModel.$isSelectedSuccess) {
            if $0 { dismiss() }
        }
        .onDisappear {
            viewModel.isSelectedSuccess = false
        }
    }
}
