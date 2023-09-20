//
//  RequestNoticeCellView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/08/27.
//

import SwiftUI
import SDWebImageSwiftUI

enum RequestNoticeType: String {
    case request = "Request"
    case approve = "Approve"
}

struct RequestNoticeCellView: View {
    let notice: RequestNoticeObservableModel
    @StateObject var viewModel = RequestNoticeCellViewModel()
    
    var body: some View {
        VStack{
            HStack(alignment: .top){
                if !notice.isRead {
                    Circle()
                        .foregroundColor(.customRed)
                        .frame(width: 8, height: 8)
                }
                switch RequestNoticeType(rawValue: notice.type) {
                case .request:
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.purple)
                case .approve:
                    Image(systemName: "person.2.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.orange)
                    Spacer()
                case .none:
                    Text("")
                }
                
                VStack(alignment: .leading){
                    
                    Image(notice.triggerUserProfileImageUrlString)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 40)
                        .padding(.all, 4)
                        .background(Color.gray.opacity(0.1))
                        .clipShape(Circle())
                    
                    Text(notice.createdAt)
                        .foregroundColor(.gray.opacity(0.7))
                        .font(.system(size: 12, weight: .light))
                    
                    HStack(alignment: .top, spacing: .zero){
                        switch RequestNoticeType(rawValue: notice.type) {
                        case .request:
                            Text(notice.triggerUserNickName)
                                .foregroundColor(.customBlack)
                                .font(.system(size: 16, weight: .bold))
                            
                            + Text("さんから友達申請が来ました")
                                .foregroundColor(.customBlack)
                                .font(.system(size: 16))
                            
                            Spacer()
                            Button {
                                
                            } label: {
                                Text("追加する")
                                    .foregroundColor(.white)
                                    .font(.system(size: 14))
                                    .padding(.all, 8)
                                    .background(Color.purple)
                                    .cornerRadius(10)
                            }
                        case .approve:
                            Text(notice.triggerUserNickName)
                                .foregroundColor(.customBlack)
                                .font(.system(size: 16, weight: .bold))
                            + Text("さんと友達になりました！")
                                .foregroundColor(.customBlack)
                                .font(.system(size: 16))
                            Spacer()
                        case .none:
                            Text("")
                        }
                    }
                    .multilineTextAlignment(.leading)
                }
                
            }
            .padding(.horizontal, 16)
            Divider()
        }
        .padding(.vertical, 8)
    }
}
