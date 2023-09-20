//
//  FilterlingChatmateView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/06/27.
//

import SwiftUI
import SDWebImageSwiftUI

enum ChatmateKind: String {
    case all
    case friend
    case exceptFriend
}

struct FilterlingChatmateView: View {
    @ObservedObject var viewModel: FilterlingChatmateViewModel
    let user: UserObservableModel
    let allChatmateUsers: [UserObservableModel]
    @Binding var chatmateUsers: [UserObservableModel]
    @Binding var chatmateKind: ChatmateKind
    @Environment(\.dismiss) var dismiss
    
    init(user:UserObservableModel, allChatmateUsers:[UserObservableModel],chatmateUsers: Binding<[UserObservableModel]>, chatmateKind: Binding<ChatmateKind>) {
        _chatmateUsers = chatmateUsers
        _chatmateKind = chatmateKind
        self.user = user
        self.allChatmateUsers = allChatmateUsers
        self.viewModel = .init(chatmateBinding: chatmateUsers, chatmateKind: chatmateKind)
    }
    
    var body: some View {
        VStack(alignment: .leading){
            HStack {
                Image(systemName: chatmateKind == .all ? "checkmark.square.fill": "squareshape.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.customBlack)
                    .id(UUID())
                
                Text("全て")
                    .foregroundColor(.customBlack)
                    .font(.system(size: 18))
            }
            .onTapGesture {
                chatmateKind = .all
            }
            
            HStack {
                Image(systemName: chatmateKind == .friend ? "checkmark.square.fill": "squareshape.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.customBlack)
                    .id(UUID())
                
                Text("友達のみ")
                    .foregroundColor(.customBlack)
                    .font(.system(size: 18))
            }
            .onTapGesture {
                chatmateKind = .friend
            }
            
            HStack {
                Image(systemName: chatmateKind == .exceptFriend ? "checkmark.square.fill": "squareshape.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.customBlack)
                    .id(UUID())
                
                Text("友達以外")
                    .foregroundColor(.customBlack)
                    .font(.system(size: 18))
            }
            .onTapGesture {
                chatmateKind = .exceptFriend
            }
        }
        .frame(width: UIScreen.main.bounds.width-32)
        .foregroundColor(.customBlack)
        .font(.system(size: 16))
        .padding(.horizontal, 16)
        .onChange(of: chatmateKind) { _ in
            viewModel.filter(user: user, allChatmate: allChatmateUsers)
        }
        
    }
}
