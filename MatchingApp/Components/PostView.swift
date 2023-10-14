//
//  RecruitmentView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/03.
//

import SwiftUI
import SDWebImageSwiftUI

struct PostView: View {
    let post: PostObservableModel
    @StateObject var viewModel = PostViewModel()
    @EnvironmentObject var userModel: UserObservableModel
    
    var body: some View {
        VStack {
            HStack(alignment: .top){
                NavigationLink {
                    UserProfileView(userId: post.posterUid, isFromHome: false)
                } label: {
                    Image(post.posterProfileImageUrlString)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)
                        .padding(.all, 8)
                        .background(Color.customLightGray)
                        .clipShape(Circle())
                }
                VStack(alignment: .leading) {
                    HStack {
                        Text(post.posterNickName)
                            .foregroundColor(.customBlack)
                            .font(.system(size: 18, weight: .bold))
                        Spacer()
                        Text(post.createdAt)
                            .foregroundColor(.gray.opacity(0.6))
                            .font(.system(size: 14))
                        
                        Text("")
                            .frame(width: 24, height: 24)
                            .padding(.leading, 4)
                    }
                    
                    if !post.mentionUserNickName.isEmpty {
                        Text("Re:\(post.mentionUserNickName)")
                            .foregroundColor(.white)
                            .font(.system(size: 12))
                            .padding(.vertical, 4)
                            .padding(.horizontal, 8)
                            .background(Color.customBlue.opacity(0.5))
                            .cornerRadius(10)
                    }
                    
                    ScrollView {
                        VStack(alignment: .leading){
                            Text(post.text)
                                .foregroundColor(.customBlack)
                                .font(.system(size: 16))
                                .multilineTextAlignment(.leading)
                            
                            if !post.contentImageUrlStrings.isEmpty {
                                LazyVStack {
                                    HStack {
                                        LazyVGrid(columns: Array(repeating: .init(.fixed((UIScreen.main.bounds.width / 4)), spacing: 8), count: 2)) {
                                            ForEach(post.contentImageUrlStrings, id: \.self) { contentImageString in
                                                Button {
                                                    self.viewModel.selectedPhoto = contentImageString
                                                    self.viewModel.isPhotoPreview = true
                                                } label: {
                                                    WebImage(url: URL(string: contentImageString))
                                                        .resizable()
                                                        .indicator(.activity)
                                                        .transition(.fade(duration: 0.5))
                                                        .scaledToFill()
                                                        .frame(width: (UIScreen.main.bounds.width)/4, height: (UIScreen.main.bounds.width)/4)
                                                        .background(Color.gray.opacity(0.1))
                                                        .cornerRadius(10)
                                                }
                                            }
                                        }
                                        Spacer()
                                    }
                                }
                            }
                        }
                    }
                    
                    HStack {
                        Spacer()
                        Button {
                            self.viewModel.isReplyModal = true
                        } label: {
                            HStack {
                                Image(systemName: "arrowshape.turn.up.left.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20, height: 20)
                                    .foregroundColor(post.replys.keys.contains(userModel.user.uid) ? Color.green.opacity(0.8): Color.gray.opacity(0.4))
                                
                                Text("\(post.replys.keys.count)")
                                    .foregroundColor(Color.gray.opacity(0.4))
                                    .font(.system(size: 14))
                            }
                        }
                        HStack {
                            Button {
                                self.viewModel.handleLikeButtonPress(
                                    userModel: userModel,
                                    postModel: post
                                )
                            } label: {
                                ZStack {
                                    Image(systemName: viewModel.isLiked ? "heart.fill" : "heart")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(viewModel.isLiked ? Color.customRed: Color.gray.opacity(0.4))
                                }
                            }
                            
                            Text("\(viewModel.isLikedNum)")
                                .foregroundColor(Color.gray.opacity(0.4))
                                .font(.system(size: 14))
                        }
                        .padding(.leading, 24)
                    }
                    .padding(.top, 8)
                }
                .padding(.leading, 16)
                Spacer()
            }
            .padding(.horizontal, 16)
        }
        .padding(.vertical, 8)
        .frame(width: UIScreen.main.bounds.width-32)
        .sheet(isPresented: $viewModel.isPhotoPreview){
            PreviewPictureView(imageUrlString: viewModel.selectedPhoto, postText: post.text)
        }
        .fullScreenCover(isPresented: $viewModel.isReplyModal){
            CreateReplyPostView(post: post, fromUser: userModel)
        }
        .onAppear {
            viewModel.initial(userModel: userModel, post: post)
        }
    }
}
