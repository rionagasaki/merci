//
//  HomeView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/01.
//

import SwiftUI
import Combine
import AlertToast

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var userModel: UserObservableModel
    let UIIFGeneratorMedium = UIImpactFeedbackGenerator(style: .heavy)
    
    var body: some View {
        VStack(spacing: .zero) {
            CustomScrollView(
                menus: ["友達投稿","投稿","自分"],
                postFilter: $viewModel.postFilter,
                selection: $viewModel.selection
            )
            .frame(height: 40)
            
            TabBarSliderView(width: 100.0, alignment: .top)
            
            VStack(spacing: 20){
                TabView(selection: $viewModel.selection){
                    FriendPostView(viewModel: viewModel)
                        .tag(0)
                    
                    AllPostView(viewModel: viewModel)
                        .tag(1)
                    
                    UserProfileView(
                        userId: userModel.user.uid,
                        isFromHome: true
                    )
                    .tag(2)
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            }
        }
        .onAppear {
            if viewModel.allPosts.count == 0 {
                viewModel.initialAllPostAndCall(userModel: userModel)
            }
        }
        .alert(isPresented: $viewModel.isErrorAlert) {
            Alert(title: Text("エラー"), message: Text(viewModel.errorMessage))
        }
        .toast(isPresenting: $viewModel.isCompleteToast) {
            AlertToast(type: .complete(Color.green), title: "プロフに固定しました！")
        }
        .toast(isPresenting: $viewModel.isDeleteToast) {
            AlertToast(type: .error(Color.customRed), title: "つぶやきを消したよ！")
        }
    }
}


struct AllPostView: View {
    @StateObject var viewModel: HomeViewModel
    @EnvironmentObject var userModel: UserObservableModel
    @ObservedObject var reloadPost = ReloadPost.shared
    let UIIFGeneratorMedium = UIImpactFeedbackGenerator(style: .heavy)
    
    var body: some View {
        NavigationStack {
            ScrollViewReader { scrollReader in
                ScrollView {
                    VStack {
                        VStack {
                            LazyVStack {
                                if viewModel.isLoading {
                                    ProgressView()
                                } else {
                                    ForEach(viewModel.postFilter == .allPostsAndReplys ? viewModel.allPosts.indices: viewModel.filterlingParentPost.indices, id: \.self) { index in
                                        let post = viewModel.postFilter == .allPostsAndReplys ? viewModel.allPosts[index]: viewModel.filterlingParentPost[index]
                                        let count = viewModel.postFilter == .allPostsAndReplys ? viewModel.allPosts.count: viewModel.filterlingParentPost.count
                                        ZStack(alignment: .topTrailing) {
                                            NavigationLink {
                                                PostDetailView(
                                                    savedScrollDocumentID: Binding<String?>($viewModel.savedScrollDocumentId),
                                                    postId: post.id
                                                )
                                                .onAppear {
                                                    viewModel.savedScrollDocumentId = ""
                                                }
                                            } label: {
                                                PostView(post: post)
                                                    .background(Color.white)
                                                    .cornerRadius(20)
                                                    .onAppear {
                                                        if index == count - 1 {
                                                            if !viewModel.isLastDocumentLoaded {
                                                                viewModel.getNextPage(userModel: userModel)
                                                            }
                                                        }
                                                    }
                                            }
                                            if post.posterUid == userModel.user.uid {
                                                PostMenu(text1: "投稿を固定する", text2: "投稿を削除する"){
                                                    viewModel.pinnedPost(postID: post.id, userID: post.posterUid)
                                                } deleteAction: {
                                                    viewModel.deletePost(postID: post.id, userModel: userModel)
                                                }
                                            }
                                        }
                                        .id(UUID(uuidString: post.id))
                                    }
                                }
                            }
                        }
                        .padding(.vertical, 16)
                        
                        if !viewModel.isLastDocumentLoaded && !viewModel.isLoading {
                            ProgressView()
                                .frame(width: 30, height: 30)
                                .padding(.bottom, 8)
                        }
                    }
                    .onChange(of: viewModel.savedScrollDocumentId){ _ in
                        print("after count \(viewModel.allPosts.count)")
                        withAnimation {
                            scrollReader.scrollTo(UUID(uuidString: viewModel.savedScrollDocumentId), anchor: .some(.center))
                        }
                    }
                }
            }
        }
        .background(Color.gray.opacity(0.1))
        .onChange(of: reloadPost.isRequiredReload) {
            if $0 {
                viewModel.getLatestPosts(userModel: userModel)
                reloadPost.isRequiredReload = false
            }
        }
        .refreshable {
            UIIFGeneratorMedium.impactOccurred()
            viewModel.getLatestPosts(userModel: userModel)
        }
    }
}

struct FriendPostView: View {
    @StateObject var viewModel: HomeViewModel
    @EnvironmentObject var userModel: UserObservableModel
    @ObservedObject var reloadPost = ReloadPost.shared
    let UIIFGeneratorMedium = UIImpactFeedbackGenerator(style: .heavy)
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: .zero){
                    Text("友達")
                        .foregroundColor(.customBlack)
                        .font(.system(size: 24, weight: .medium))
                        .padding(.top, 16)
                        .frame(width: UIScreen.main.bounds.width-32, alignment: .leading)
                        .padding(.bottom, 8)
                    ScrollView(.horizontal, showsIndicators: false) {
                        if viewModel.friendUsers.count == 0 {
                            Text("まだ友達がいないよ😢")
                                .foregroundColor(.customBlack)
                                .font(.system(size: 20, weight: .medium))
                                .padding(.horizontal, 16)
                        } else {
                            HStack {
                                ForEach(viewModel.friendUsers) { user in
                                    NavigationLink {
                                        UserProfileView(userId: user.user.uid, isFromHome: false)
                                    } label: {
                                        VStack {
                                            Image(user.user.profileImageURLString)
                                                .resizable()
                                                .scaledToFill()
                                                .frame(width: 48, height: 48)
                                                .padding(.all, 6)
                                                .background(Color.gray.opacity(0.1))
                                                .clipShape(Circle())
                                            
                                            Text(user.user.nickname)
                                                .foregroundColor(.customBlack)
                                                .font(.system(size: 12, weight: .medium))
                                                .lineLimit(1)
                                                .frame(width: 70)
                                        }
                                        .padding(.trailing, 8)
                                    }
                                }
                            }
                            .padding(.horizontal, 16)
                        }
                    }
                    .padding(.vertical, 16)
                    .background(Color.white)
                    .cornerRadius(20)
                    .padding(.horizontal, 16)
                }
                
                VStack {
                        LazyVStack {
                            if viewModel.isLoading {
                                ProgressView()
                            } else {
                                ForEach(viewModel.postFilter == .allPostsAndReplys ? viewModel.friendPosts.indices: viewModel.friendFilterlingParentPost.indices, id: \.self) { index in
                                    let post = viewModel.postFilter == .allPostsAndReplys ? viewModel.friendPosts[index]: viewModel.friendFilterlingParentPost[index]
                                    let count = viewModel.postFilter == .allPostsAndReplys ? viewModel.friendPosts.count: viewModel.friendFilterlingParentPost.count
                                    ZStack(alignment: .topTrailing){
                                        NavigationLink {
                                            PostDetailView(
                                                savedScrollDocumentID: Binding<String?>($viewModel.savedScrollDocumentId),
                                                postId: post.id
                                            )
                                        } label: {
                                            PostView(post: post)
                                                .background(Color.white)
                                                .cornerRadius(20)
                                                .onAppear {
                                                    if index == count - 1 {
                                                        if !viewModel.isFriendDocumentLoaded {
                                                            viewModel.getFriendNextPage(userModel: userModel)
                                                        }
                                                    }
                                                }
                                        }
                                        if post.posterUid == userModel.user.uid {
                                            PostMenu(text1: "投稿を固定する", text2: "投稿を削除する"){
                                                viewModel.pinnedPost(postID: post.id, userID: post.posterUid)
                                            } deleteAction: {
                                                viewModel.deletePost(postID: post.id, userModel: userModel)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    if !viewModel.isFriendDocumentLoaded && userModel.user.friendUids.count != 0 {
                            ProgressView()
                                .frame(width: 30, height: 30)
                                .padding(.bottom, 8)
                        }
                   
                }
                .padding(.vertical, 16)
            }
        }
        .onReceive(reloadPost.$isRequiredReload) {
            if $0 {
                viewModel.getLatestFriendPost(userModel: userModel)
            }
        }
        .refreshable {
            UIIFGeneratorMedium.impactOccurred()
            viewModel.getLatestFriendPost(userModel: userModel)
            viewModel.getConcurrentUserInfo(userIDs: userModel.user.friendUids)
        }
        .background(Color.gray.opacity(0.1))
    }
}
