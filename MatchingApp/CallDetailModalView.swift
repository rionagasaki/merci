//
//  CallDetailModal.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/08/06.
//

import SwiftUI
import SDWebImageSwiftUI
import AmazonChimeSDK

struct CallDetailModalView: View {
    @StateObject var viewModel = CallDetailModalViewModel()
    @Environment(\.dismiss) var dismiss
    @Binding var isActive: Bool
    let call: CallObservableModel
    let user: UserObservableModel
    var body: some View {
        
        VStack {
            HStack {
                Text("オープン通話")
                    .foregroundColor(.pink)
                    .font(.system(size: 12))
                Text("\(call.call.userIdToUserIconImageUrlString.keys.count)人が参加中")
                    .foregroundColor(.customBlack)
                    .font(.system(size: 12))
                Spacer()
            }
            HStack(alignment: .top){
                Image(call.call.hostUserImageUrlString)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 80, height: 80)
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(10)
                
                VStack(alignment: .leading){
                    Text(call.call.channelTitle)
                        .foregroundColor(.customBlack)
                        .font(.system(size: 32, weight: .bold))
                        .lineLimit(nil)
                        .fixedSize(horizontal: false, vertical: true)
                    Spacer()
                    Text(call.call.userIdToUserName[call.call.hostUserId] ?? "")
                        .foregroundColor(.customBlack)
                        .font(.system(size: 12, weight: .bold))
                    
                    Text("\(call.call.createdAt)に開始")
                        .foregroundColor(.gray.opacity(0.8))
                        .font(.system(size: 12))
                }
                .frame(height: 80)
                Spacer()
            }
            
            Spacer()
            Divider()
            VStack {
                Button {
                    if !user.user.isCallingChannelId.isEmpty {
                        viewModel.errorMessage = "すでに、他の通話に参加中です"
                        viewModel.isErrorAlert = true
                        dismiss()
                    } else {
                        dismiss()
                        self.isActive = true
                    }
                } label: {
                    Text("通話に参加する")
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .bold))
                        .frame(width: UIScreen.main.bounds.width-32, height: 50)
                        .background(Color.customRed)
                        .cornerRadius(25)
                    
                }
                Text("⚠️開始時にはマイクはオフになります")
                    .foregroundColor(.customBlack)
                    .font(.system(size: 12))
            }
            .padding(.bottom, 24)
        }
        
        .padding(.top, 24)
        .frame(width: UIScreen.main.bounds.width-48, height: UIScreen.main.bounds.height/2)
    }
}
