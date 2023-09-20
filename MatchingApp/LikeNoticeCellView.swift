//
//  LikeNoticeCellView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/08/27.
//

import SwiftUI
import SDWebImageSwiftUI

struct LikeNoticeCellView: View {
    
    let notice: LikeNoticeObservableModel
    var body: some View {
        VStack(alignment: .leading){
            HStack(alignment: .top){
                Image(systemName: "heart.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.pink)
                
                VStack(alignment: .leading){
                    HStack {
                        ForEach(Array<String>(notice.triggerUserProfileImageUrlStringMapping.keys), id: \.self) { uid in
                            if let profileImage = notice.triggerUserProfileImageUrlStringMapping[uid], !profileImage.isEmpty {
                                Image(profileImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 40, height: 40)
                                    .padding(.all, 4)
                                    .background(Color.gray.opacity(0.1))
                                    .clipShape(Circle())
                            }
                        }
                    }
                    
                    if Array<String>(notice.triggerUserNickNameMapping.keys).count == 1 {
                        HStack(alignment: .top, spacing: .zero){
                            Text("\(notice.triggerUserNickNameMapping[notice.lastTriggerUserUid] ?? "")")
                                .foregroundColor(.customBlack)
                                .font(.system(size: 16, weight: .medium))
                            + Text("さんがあなたのつぶやきにいいねしました")
                                .foregroundColor(.customBlack)
                                .font(.system(size: 16))
                        }
                        .multilineTextAlignment(.leading)
                    } else {
                        HStack(alignment: .top, spacing: .zero){
                            Text("\(notice.triggerUserNickNameMapping[notice.lastTriggerUserUid] ?? "")")
                                .foregroundColor(.customBlack)
                                .font(.system(size: 16, weight: .medium))
                            + Text("さんらがあなたのつぶやきにいいねしました")
                                .foregroundColor(.customBlack)
                                .font(.system(size: 16))
                        }
                        .multilineTextAlignment(.leading)
                    }
                    
                    Text(notice.createdAt)
                        .foregroundColor(.gray.opacity(0.7))
                        .font(.system(size: 12, weight: .light))
                    
                    Text(notice.recieverPostText)
                        .foregroundColor(.gray.opacity(0.8))
                        .font(.system(size: 16))
                        .padding(.top, 8)
                }
                Spacer()
            }
            Divider()
        }
        .padding(.horizontal, 16)
    }
}
