//
//  CommentNoticeCellView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/08/27.
//

import SwiftUI
import SDWebImageSwiftUI

struct CommentNoticeCellView: View {
    let notice: CommentNoticeObservableModel
    var body: some View {
        VStack {
            HStack(alignment: .top){
                if !notice.isRead {
                    Circle()
                        .foregroundColor(.customRed)
                        .frame(width: 8, height: 8)
                }
                Image(systemName: "bubble.right.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.green)
                
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
                                .foregroundColor(.black)
                                .font(.system(size: 16, weight: .bold))
                            + Text("さんがあなたのつぶやきにコメントを残しました")
                                .foregroundColor(.black)
                                .font(.system(size: 16))
                                
                        }
                        .multilineTextAlignment(.leading)
                    } else {
                        HStack(alignment: .top, spacing: .zero){
                            Text("\(notice.triggerUserNickNameMapping[notice.lastTriggerUserUid] ?? "")")
                                .foregroundColor(.black)
                                .font(.system(size: 16, weight: .bold))
                            + Text("さんら他\(Array<String>(notice.triggerUserNickNameMapping.keys).count)人が、あなたのつぶやきにコメントを残しました")
                                .foregroundColor(.black)
                                .font(.system(size: 16))
                        }
                        .multilineTextAlignment(.leading)
                    }
                    Text(notice.createdAt)
                        .foregroundColor(.gray.opacity(0.7))
                        .font(.system(size: 12, weight: .light))
                    
                    Text(notice.lastTriggerCommentText)
                        .foregroundColor(.gray.opacity(0.8))
                        .font(.system(size: 16))
                        .padding(.top, 8)
                        .multilineTextAlignment(.leading)
                        .padding(.trailing, 8)
                }
            }
            Divider()
        }
        .padding(.horizontal, 8)
    }
}
