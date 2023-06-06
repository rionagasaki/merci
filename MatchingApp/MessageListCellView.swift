//
//  SendGoodsListCellView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/06/02.
//

import SwiftUI
import SDWebImageSwiftUI

struct MessageListCellView: View {
    // 
    let pair: PairObservableModel
    var body: some View {
        NavigationLink {
            ChatView(pair: pair)
        } label: {
            VStack {
                Divider()
                HStack {
                    VStack(alignment: .leading){
                        HStack(alignment: .top){
                            WebImage(url: URL(string: pair.pair_1_profileImageURL))
                                .resizable()
                                .frame(width: 60, height: 60)
                                .cornerRadius(5)
                            VStack(alignment: .leading){
                                Text(pair.pair_1_nickname)
                                    .foregroundColor(.pink.opacity(0.7))
                                Text(pair.pair_1_activeRegion)
                                    .foregroundColor(.black)
                            }
                            
                            .font(.system(size: 13, weight: .light))
                            WebImage(url: URL(string: pair.pair_2_profileImageURL))
                                .resizable()
                                .frame(width: 60, height: 60)
                                .cornerRadius(5)
                                .padding(.leading, 16)
                            VStack(alignment: .leading){
                                Text(pair.pair_2_nickname)
                                    .foregroundColor(.pink.opacity(0.7))
                                Text(pair.pair_2_activeRegion)
                                    .foregroundColor(.black)
                            }
                            .font(.system(size: 13, weight: .light))
                            Spacer()
                        }
                        Text("こんにちは！！こんにちは！！！！！！fjdsilajflsdjfsalkdfjskdlafjakldfdjklfdafsdafs")
                            .lineLimit(1)
                            .padding(.trailing, 16)
                            .foregroundColor(.black)
                            .font(.system(size:16,weight: .light))
                        Text("06/04/ 16:51")
                            .foregroundColor(.gray.opacity(0.5))
                            .font(.system(size: 12, weight: .light))
                    }
                    .padding(.leading, 16)
                    .padding(.top, 16)
                    .padding(.bottom, 8)
                    Image(systemName: "chevron.right")
                        .resizable()
                        .frame(width: 7, height: 10)
                        .scaledToFill()
                        .foregroundColor(.black)
                        .padding(.trailing, 8)
                }
                Divider()
            }
        }

    }
}

struct SendGoodsListCellView_Previews: PreviewProvider {
    static var previews: some View {
        MessageListCellView(pair: .init())
    }
}
