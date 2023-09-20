//
//  HomeView.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/01.
//

import SwiftUI
import Combine

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var userModel: UserObservableModel
    let UIIFGeneratorMedium = UIImpactFeedbackGenerator(style: .heavy)
    
    var body: some View {
        VStack(spacing: .zero) {
            CustomScrollView(
                menus: ["友達投稿","投稿","悩み","自分"],
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
                            VStack {
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack {
                                        StartCallButton()
                                            .zIndex(1)
                                        ForEach(viewModel.callsToAllUsers) { call in
                                            JoinCallButton(call: call)
                                                .padding(.trailing, 12)
                                        }
                                    }
                                }
                                .frame(height: 100)
                            }
                            
                            LazyVStack {
                                if viewModel.isLoading {
                                    ProgressView()
                                } else {
                                    ForEach(viewModel.postFilter == .allPosts ? viewModel.allPosts.indices: viewModel.filterlingParentPost.indices, id: \.self) { index in
                                        let post = viewModel.postFilter == .allPosts ? viewModel.allPosts[index]: viewModel.filterlingParentPost[index]
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
                                                        if index == viewModel.allPosts.count - 1 {
                                                            if !viewModel.isLastDocumentLoaded {
                                                                viewModel.getNextPage(userModel: userModel)
                                                            }
                                                        }
                                                    }
                                            }
                                            
                                            if post.posterUid == userModel.user.uid {
                                                Menu {
                                                    Button {
                                                        
                                                    } label: {
                                                        Label("投稿を固定する", systemImage: "pin.fill")
                                                    }
                                                    
                                                    Button(role: .destructive) {
                                                        viewModel.deletePost(postID: post.id, userModel: userModel)
                                                    } label: {
                                                        Label("投稿を削除する", systemImage: "minus.circle.fill")
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
                        HStack {
                            ForEach(viewModel.friendUsers) { user in
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
                                }
                                .padding(.trailing, 8)
                            }
                        }
                        .padding(.horizontal, 16)
                    }
                    .frame(height: 100)
                    .background(Color.white)
                    .cornerRadius(24)
                    .padding(.horizontal, 16)
                }
                
                VStack {
                        LazyVStack {
                            if viewModel.isLoading {
                                ProgressView()
                            } else {
                                ForEach(viewModel.friendPosts.indices, id: \.self) { index in
                                    let post = viewModel.friendPosts[index]
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
                                                    print("allIndex", index)
                                                    if index == viewModel.friendPosts.count - 1 {
                                                        if !viewModel.isFriendDocumentLoaded {
                                                            viewModel.getFriendNextPage(userModel: userModel)
                                                        }
                                                    }
                                                }
                                        }
                                        if post.posterUid == userModel.user.uid {
                                            Menu {
                                                Button {
                                                    
                                                } label: {
                                                    Label("投稿を固定する", systemImage: "pin.fill")
                                                }
                                                
                                                Button(role: .destructive) {
                                                    viewModel.deletePost(postID: post.id, userModel: userModel)
                                                } label: {
                                                    Label("投稿を削除する", systemImage: "minus.circle.fill")
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
                                }
                            }
                        }
                        if !viewModel.isFriendDocumentLoaded {
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
        }
        .background(Color.gray.opacity(0.1))
    }
}
