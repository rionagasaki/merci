//
//  HomeViewModel.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/01.
//

import SwiftUI
import Combine

class HomeViewModel: ObservableObject {
    @Published var selection: Int = 1
    @Published var isLoading: Bool = false
    @Published var reloadPost: Bool = false
    
    @Published var postFilter: PostFilter = .allPostsAndReplys
    @Published var callsToAllUsers:[CallObservableModel] = []
    @Published var callsToFriends:[CallObservableModel] = []
    
    @Published var allPosts: [PostObservableModel] = []
    @Published var friendPosts: [PostObservableModel] = []
    @Published var filterlingParentPost: [PostObservableModel] = []
    
    @Published var friendUsers: [UserObservableModel] = []
    
    @Published var isLastDocumentLoaded: Bool = false
    @Published var isFriendDocumentLoaded: Bool = false
    @Published var savedScrollDocumentId: String = ""
    
    @Published var isErrorAlert: Bool = false
    @Published var errorMessage: String = ""
    private let userService = UserFirestoreService()
    private let callService = CallFirestoreService()
    private let postService = PostFirestoreService()
    private var cancellable = Set<AnyCancellable>()
    
    func initialAllPostAndCall(userModel: UserObservableModel) {
        self.callService.getCall()
            .flatMap { calls in
                self.callsToAllUsers = calls.filter({ call in
                    call.call.isFriendCalling == false
                })
                return self.userService.getConcurrentUserInfo(userIDs: userModel.user.friendUids)
            }
            .flatMap { users in
                self.friendUsers = users.map { .init(userModel: $0.adaptUserObservableModel()) }
                return self.postService.getAllPost(target: .`init`)
            }
            .sink { completion in
                switch completion {
                case .finished:
                    print("finish")
                case .failure(let error):
                    self.errorMessage = error.errorMessage
                    self.isErrorAlert = true
                }
            } receiveValue: { [weak self] posts in
                guard let self = self else { return }
                self.allPosts = []
                self.friendPosts = []
                self.filterlingParentPost = []
                self.processPosts(posts: posts, userModel: userModel)
                self.processFriendPost(posts: posts, userModel: userModel)
            }
            .store(in: &self.cancellable)
    }
    
    func getNextPage(userModel: UserObservableModel) {
        postService.getNextPage()
            .sink { completion in
                switch completion {
                case .finished:
                    print("finish")
                case .failure(let error):
                    self.errorMessage = error.errorMessage
                    self.isErrorAlert = true
                }
            } receiveValue: { [weak self] posts in
                guard let self = self else { return }
                if posts.count < 20 {
                    self.isLastDocumentLoaded = true
                }
                self.processPosts(posts: posts, userModel: userModel)
            }
            .store(in: &self.cancellable)
    }
    
    func getFriendNextPage(userModel: UserObservableModel) {
        postService.getFriendNextPage()
            .sink { completion in
                switch completion {
                case .finished:
                    print("finish")
                case .failure(let error):
                    self.errorMessage = error.errorMessage
                    self.isErrorAlert = true
                }
            } receiveValue: { [weak self] posts in
                guard let self = self else { return }
                if !self.isFriendDocumentLoaded {
                    if posts.count < 20 {
                        self.isFriendDocumentLoaded = true
                    }
                    self.processFriendPost(posts: posts, userModel: userModel)
                }
            }
            .store(in: &self.cancellable)
    }
    
    func getLatestPosts(userModel: UserObservableModel) {
        self.isLoading = true
        postService.getAllPost(target: .all)
            .sink { completion in
                switch completion {
                case .finished:
                    print("finish")
                case .failure(let error):
                    self.errorMessage = error.errorMessage
                    self.isErrorAlert = true
                }
            } receiveValue: { [weak self] posts in
                guard let self = self else { return }
                self.refreshPost(posts: posts, userModel: userModel)
            }
            .store(in: &self.cancellable)
    }
    
    func getLatestFriendPost(userModel: UserObservableModel) {
        self.isLoading = true
        postService.getAllPost(target: .friend)
            .sink { completion in
                switch completion {
                case .finished:
                    print("finish")
                case .failure(let error):
                    self.errorMessage = error.errorMessage
                    self.isErrorAlert = true
                }
            } receiveValue: { [weak self] posts in
                self?.refreshFriendPost(posts: posts, userModel: userModel)
            }
            .store(in: &self.cancellable)
    }
    
    func refreshPost(posts: [Post], userModel: UserObservableModel) {
        self.allPosts = []
        self.filterlingParentPost = []
        for post in posts {
            let postObservableModel = post.adaptPostObservableModel()
            withAnimation {
                self.allPosts.append(postObservableModel)
            }
            if postObservableModel.parentPosts == [] {
                self.filterlingParentPost.append(postObservableModel)
            }
        }
        self.isLastDocumentLoaded = false
        self.isLoading = false
    }
    
    func refreshFriendPost(posts:[Post], userModel: UserObservableModel) {
        let friendUids = userModel.user.friendUids
        let uid = userModel.user.uid
        self.friendPosts = []
        for post in posts {
            let postObservableModel = post.adaptPostObservableModel()
            if friendUids.contains(post.posterUid) || uid == post.posterUid {
                self.friendPosts.append(postObservableModel)
            }
        }
        self.isFriendDocumentLoaded = false
        self.isLoading = false
    }
    
    func processPosts(posts: [Post], userModel: UserObservableModel) {
        for post in posts {
            let postObservableModel = post.adaptPostObservableModel()
            self.allPosts.append(postObservableModel)
            
            if postObservableModel.parentPosts == [] {
                self.filterlingParentPost.append(postObservableModel)
            }
        }
    }
    
    func processFriendPost(posts: [Post], userModel: UserObservableModel) {
        let friendUids = userModel.user.friendUids
        let uid = userModel.user.uid
        if posts.filter({ post in friendUids.contains(post.posterUid) || uid == post.posterUid }).count == 0 {
            self.getFriendNextPage(userModel: userModel)
        } else {
            for post in posts {
                if friendUids.contains(post.posterUid) || uid == post.posterUid {
                    let postObservableModel = post.adaptPostObservableModel()
                    self.friendPosts.append(postObservableModel)
                }
            }
        }
    }
    
    func deletePost(postID: String, userModel: UserObservableModel) {
        self.postService
            .deletePost(postID: postID)
            .sink { completion in
                switch completion {
                case .finished:
                    self.getLatestPosts(userModel: userModel)
                case .failure(let error):
                    self.isErrorAlert = true
                    self.errorMessage = error.errorMessage
                }
            } receiveValue: { _ in
                print("recieve value")
            }
            .store(in: &self.cancellable)
    }
}
