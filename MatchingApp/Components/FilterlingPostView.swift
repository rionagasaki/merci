//
//  NotificationView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/07/06.
//

import SwiftUI

enum PostFilter {
    case allPostsAndReplys
    case allPosts
}

struct FilterlingPostView: View {
    @StateObject var viewModel = FilterlingPostViewModel()
    @EnvironmentObject var userModel: UserObservableModel
    @Binding var postFilter: PostFilter
    @State var postFileterForImage: PostFilter = .allPosts
    var body: some View {
        
        VStack {
            if viewModel.isLoading {
                ProgressView()
            } else {
                VStack {
                    Spacer()
                    HStack {
                        Image(systemName: self.postFileterForImage == .allPostsAndReplys ? "checkmark.square.fill": "squareshape.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.customBlack)
                        Text("投稿・リプライ全てを表示する")
                            .foregroundColor(.customBlack)
                            .font(.system(size: 18))
                        Spacer()
                    }
                    .onTapGesture {
                        viewModel.updateIsDisplayOnlyPost(userID: userModel.user.uid, isDisplayOnlyPost: .allPostsAndReplys) {
                            self.postFilter = .allPostsAndReplys
                            self.postFileterForImage = .allPostsAndReplys
                        }
                    }
                    
                    HStack {
                        Image(systemName: self.postFileterForImage == .allPosts ? "checkmark.square.fill": "squareshape.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.customBlack)
                        Text("投稿のみを表示する")
                            .foregroundColor(.customBlack)
                            .font(.system(size: 18))
                        Spacer()
                    }
                    .onTapGesture {
                        viewModel.updateIsDisplayOnlyPost(userID: userModel.user.uid, isDisplayOnlyPost: .allPosts){
                            self.postFilter = .allPosts
                            self.postFileterForImage = .allPosts
                        }
                    }
                    Spacer()
                }
            }
        }
        .frame(width: UIScreen.main.bounds.width-32)
        .onAppear {
            self.postFileterForImage = self.postFilter
        }
    }
}
