//
//  SendGoodsListCellView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/06/02.
//

import SwiftUI
import SDWebImageSwiftUI

struct MessageListCellView: View {
    let pair: PairObservableModel
    @EnvironmentObject var pairModel: PairObservableModel
    @EnvironmentObject var userModel: UserObservableModel
    var body: some View {
        VStack {
            VStack(alignment: .leading){
                HStack(alignment: .top){
                    WebImage(url: URL(string: pair.pair.pair_1_profileImageURL))
                        .resizable()
                        .frame(width: 60, height: 60)
                        .cornerRadius(5)
                    VStack(alignment: .leading){
                        Text(pair.pair.pair_1_nickname)
                            .foregroundColor(.pink.opacity(0.7))
                        Text(pair.pair.pair_1_activeRegion)
                            .foregroundColor(.customBlack)
                    }
                    .font(.system(size: 13, weight: .bold))
                    
                    WebImage(url: URL(string: pair.pair.pair_2_profileImageURL))
                        .resizable()
                        .frame(width: 60, height: 60)
                        .cornerRadius(5)
                        .padding(.leading, 16)
                    VStack(alignment: .leading){
                        Text(pair.pair.pair_2_nickname)
                            .foregroundColor(.pink.opacity(0.7))
                        Text(pair.pair.pair_2_activeRegion)
                            .foregroundColor(.customBlack)
                    }
                    .font(.system(size: 13, weight: .bold))
                    Spacer()
                }
                if let chatPairLastMessage = pairModel.pair.chatPairLastMessage[pair.pair.id] {
                    HStack {
                        if userModel.user.unreadMessageCount[pairModel.pair.chatPairIDs[pair.pair.id]!] != 0
                        {
                            Circle()
                                .foregroundColor(.red)
                                .frame(width: 10, height:10)
                        }
                        Text(chatPairLastMessage)
                            .lineLimit(1)
                            .padding(.trailing, 16)
                            .foregroundColor(.black)
                            .font(.system(size:16,weight: userModel.user.unreadMessageCount[pairModel.pair.chatPairIDs[pair.pair.id]!] != 0
                                          ? .bold: .light))
                    }
                }
                if let currentDate = pairModel.pair.chatPairLastCreatedAt[pair.pair.id] {
                    Text(DateFormat.shared.customDateFormat(date: currentDate.dateValue()))
                        .foregroundColor(.gray.opacity(0.5))
                        .font(.system(size: 12, weight: .light))
                }
                
            }
            .padding(.leading, 16)
            .padding(.top, 16)
            .padding(.bottom, 8)
            
        }
    }
}

struct SendGoodsListCellView_Previews: PreviewProvider {
    static var previews: some View {
        MessageListCellView(pair: .init(pairModel: .init()))
    }
}
