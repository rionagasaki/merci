//
//  UserProfileView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/26.
//

import SwiftUI
import SDWebImageSwiftUI
import AlertToast
import Popovers


struct UserProfileView: View {
    let userId: String
    let isFromHome: Bool
    @Environment(\.presentationMode) var presentationMode
    @StateObject var viewModel = UserProfileViewModel()
    @EnvironmentObject var userModel: UserObservableModel
    let UIIFGeneratorMedium = UIImpactFeedbackGenerator(style: .heavy)
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack {
                if let user = viewModel.user {
                    UserBaseProfileView(user: user)
                        .padding(.top, 32)
                    LazyVStack {
                        if viewModel.isLoading {
                            ProgressView()
                        } else {
                            if !(userModel.user.blockedUids.contains(userId) || userModel.user.blockingUids.contains(userId)) {
                                if let fixedPost = viewModel.fixedPost {
                                    VStack(alignment: .leading){
                                        HStack(spacing: 4){
                                            Image(systemName: "pin.fill")
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 10, height: 10)
                                                .foregroundColor(.customRed)
                                            Text("ピン")
                                                .font(.system(size: 14))
                                                .foregroundColor(.customBlack)
                                        }
                                        .padding(.top, 8)
                                        .padding(.leading, 16)
                                        ZStack(alignment: .topTrailing) {
                                            NavigationLink {
                                                PostDetailView(savedScrollDocumentID: .constant(nil), postId: fixedPost.id)
                                            } label: {
                                                    PostView(post: fixedPost)
                                            }
                                            if fixedPost.posterUid == userModel.user.uid {
                                                PostMenu(text1: "ピンを外す", text2: "投稿を削除する"){
                                                    viewModel.pinnedPost(postID: "", userID: fixedPost.posterUid)
                                                } deleteAction: {
                                                    viewModel.deletePost(postID: fixedPost.id, userModel: userModel)
                                                }
                                            }
                                        }
                                    }
                                    .background(Color.customBlue.opacity(0.2))
                                    .cornerRadius(20)
                                }
                                ForEach(viewModel.usersPost.indices, id: \.self) { index in
                                    let post = viewModel.usersPost[index]
                                    ZStack(alignment: .topTrailing) {
                                        NavigationLink {
                                            PostDetailView(savedScrollDocumentID: .constant(nil), postId: post.id)
                                        } label: {
                                                PostView(post: post)
                                                    .background(Color.white)
                                                    .cornerRadius(20)
                                                    .onAppear {
                                                        if index == viewModel.usersPost.count - 1 {
                                                            if !viewModel.isLastDocumentLoaded {
                                                                viewModel.getNextPage(userID: userId)
                                                            }
                                                        }
                                                    }
                                        }
                                        if post.posterUid == userModel.user.uid {
                                            PostMenu(text1: "投稿を固定する", text2: "投稿を削除する") {
                                                viewModel.pinnedPost(postID: post.id, userID: post.posterUid)
                                            } deleteAction: {
                                                viewModel.deletePost(postID: post.id, userModel: userModel)
                                            }
                                        }
                                    }
                                }
                            } else {
                                Text("\(user.user.nickname)さんのつぶやきを見ることはできません。")
                                    .foregroundColor(.customBlack)
                                    .font(.system(size: 32, weight: .medium))
                                    .padding(.horizontal, 16)
                            }
                        }
                    }
                    .padding(.bottom, 16)
                }
            }
        }
        .toast(isPresenting: $viewModel.isCompleteToast) {
            AlertToast(type: .complete(Color.green), title: "プロフに固定しました！")
        }
        .frame(width: UIScreen.main.bounds.width)
        .background(Color.gray.opacity(0.1))
        .onAppear {
            viewModel.initial(userId: self.userId)
        }
        .refreshable {
            UIIFGeneratorMedium.impactOccurred()
            viewModel.getLatestPosts()
        }
        .toolbar {
            if userModel.user.uid != userId {
                ToolbarItem {
                    Button {
                        if userModel.user.reportUserIDs.contains(userId) {
                            viewModel.errorMessage = "すでに報告済みのユーザーです。"
                            viewModel.isErrorAlert = true
                        } else {
                            viewModel.isReportAbuseModal = true
                        }
                    } label: {
                        Image(systemName: "light.beacon.min.fill")
                    }
                }
            }
        }
        .fullScreenCover(isPresented: $viewModel.isReportAbuseModal) {
            if let user = viewModel.user {
                ReportAbuseView(user: user)
            }
        }
    }
}

struct UserBaseProfileView: View {
    let user: UserObservableModel
    @EnvironmentObject var userModel: UserObservableModel
    var body: some View{
        VStack(spacing: .zero){
            Image(user.user.profileImageURLString)
                .resizable()
                .scaledToFill()
                .frame(width: 84, height: 84)
                .padding(.all, 8)
                .background(Color.gray.opacity(0.1))
                .clipShape(Circle())
            
            Text(user.user.nickname)
                .font(.system(size: 16, weight: .bold))
                .foregroundColor(.customBlack)
                .padding(.top, 5)
            
            Spacer()
            Image(user.user.gender == "男性" ? "Man": "Woman")
                .resizable()
                .scaledToFit()
                .frame(width: 24, height: 24)
            Text(user.user.introduction)
                .font(.caption)
                .padding(.horizontal,16)
                .padding(.top, 8)
            HStack {
                TagViewGenerator.generateTags(
                    UIScreen.main.bounds.width-32,
                    tags: user.user.hobbies
                )
                Spacer()
            }
            .padding(.top, 8)
            if userModel.user.uid == user.user.uid {
                CurrentUserProfileBottomView()
            } else if userModel.user.blockingUids.contains(user.user.uid) {
                ProfileBottomResolveBlockButton(toUser: user)
            } else if userModel.user.blockedUids.contains(user.user.uid) {
                EmptyView()
            } else {
                UserProfileBottomView(user: user)
            }
        }
        .padding(.all, 16)
        .frame(width: UIScreen.main.bounds.width-32)
        .background(Color.white)
        .cornerRadius(20)
    }
}


struct PostMenu: View {
    let text1: String
    let text2: String
    let fixAction: () -> Void
    let deleteAction: () -> Void
    var body: some View {
        Menu {
            Button {
                fixAction()
            } label: {
                Label(text1, systemImage: "pin.fill")
            }
            
            Button(role: .destructive) {
                deleteAction()
            } label: {
                Label(text2, systemImage: "minus.circle.fill")
            }
        } label: {
            Image(systemName: "ellipsis")
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .foregroundColor(.customBlack)
        }
        .padding(.top, 8)
        .padding(.trailing, 16)
    }
}
