//
//  HomeViewModel.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/01.
//

import SwiftUI
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var selection: Int = 1
    @Published var isLoading: Bool = false
    @Published var reloadPost: Bool = false
    @Published var isCompleteToast: Bool = false
    @Published var isDeleteToast: Bool = false
    @Published var isHiddenToast: Bool = false
    
    @Published var postFilter: PostFilter = .allPostsAndReplys
    @Published var callsToAllUsers:[CallObservableModel] = []
    
    @Published var allPosts: [PostObservableModel] = []
    @Published var friendPosts: [PostObservableModel] = []
    @Published var concernPosts: [ConcernObservableModel] = []
    @Published var filterlingParentPost: [PostObservableModel] = []
    @Published var friendFilterlingParentPost: [PostObservableModel] = []
    
    @Published var friendUsers: [UserObservableModel] = []
    @Published var onlineUsers: [UserObservableModel] = []
    
    @Published var isLastDocumentLoaded: Bool = false
    @Published var isFriendDocumentLoaded: Bool = false
    @Published var isConcernLastDocumentLoaded: Bool = false
    @Published var savedScrollDocumentId: String = ""
    
    @Published var isResolveModal: Bool = false
    @Published var isReportPostModal: Bool = false
    
    @Published var isErrorAlert: Bool = false
    @Published var errorMessage: String = ""
    private let userService = UserFirestoreService()
    private let callService = CallFirestoreService()
    private let postService = PostFirestoreService()
    private let concernService = ConcernFirestoreService()
    private var cancellable = Set<AnyCancellable>()
    
    private func handle(error: Error) {
        if let appError = error as? AppError {
            self.errorMessage = appError.errorMessage
        } else {
            self.errorMessage = error.localizedDescription
        }
        self.isErrorAlert = true
    }
    
    func initialAllPostAndCall(userModel: UserObservableModel) async {
        do {
            try await Task.sleep(nanoseconds: 2 * 1_000_000_000)
            async let getPosts = self.postService.getAllPost(target: .`init`)
            async let _ = self.getConcurrentUserInfo(userIDs: userModel.user.friendUids)
            async let getConcernPosts = self.concernService.getConcern()
            let (posts, concernPosts) = try await (getPosts, getConcernPosts)
            self.postFilter = userModel.user.isDisplayOnlyPost ? .allPosts: .allPostsAndReplys
            self.allPosts = []
            self.friendPosts = []
            self.concernPosts = []
            self.filterlingParentPost = []
            self.friendFilterlingParentPost = []
            self.processPosts(posts: posts, userModel: userModel)
            self.processConcernPosts(concernPosts: concernPosts, userModel: userModel)
            self.processFriendPost(posts: posts, userModel: userModel)
        } catch {
            self.handle(error: error)
        }
    }
    
    func getNextPage(userModel: UserObservableModel) async {
        do {
            let posts = try await postService.getNextPage()
            if posts.count < 20 {
                self.isLastDocumentLoaded = true
            }
            self.processPosts(posts: posts, userModel: userModel)
        } catch {
            self.handle(error: error)
        }
    }
    
    func getFriendNextPage(userModel: UserObservableModel) async {
        do {
            let posts = try await postService.getFriendNextPage()
            
            if !self.isFriendDocumentLoaded {
                if posts.count < 20 {
                    self.isFriendDocumentLoaded = true
                }
                self.processFriendPost(posts: posts, userModel: userModel)
            }
        } catch {
            self.handle(error: error)
        }
    }
    
    func getConcernNextPage(userModel: UserObservableModel) async {
        do {
            let concerns = try await concernService.getNextConcern()
            if !self.isConcernLastDocumentLoaded {
                if concerns.count < 20 {
                    self.isConcernLastDocumentLoaded = true
                }
            }
            self.processConcernPosts(concernPosts: concerns, userModel: userModel)
        } catch {
            self.handle(error: error)
        }
    }
    
    func getLatestPosts(userModel: UserObservableModel) async {
        self.isLoading = true
        
        do {
            let posts = try await self.postService.getAllPost(target: .`init`)
            self.refreshPost(posts: posts, userModel: userModel)
        } catch {
            self.handle(error: error)
        }
    }
    
    func getLatestFriendPost(userModel: UserObservableModel) async {
        self.isLoading = true
        do {
            let posts = try await postService.getAllPost(target: .friend)
            self.refreshFriendPost(posts: posts, userModel: userModel)
        } catch {
            self.handle(error: error)
        }
    }
    
    func getLatestConcernPost(userModel: UserObservableModel) async {
        do {
            let concerns = try await concernService.getConcern()
            self.refreshConcern(concerns: concerns, userModel: userModel)
        } catch {
            self.handle(error: error)
        }
    }
    
    func refreshPost(posts: [Post], userModel: UserObservableModel) {
        self.allPosts = []
        self.filterlingParentPost = []
        for post in posts {
            let postObservableModel = post.adaptPostObservableModel()
            if !userModel.user.blockingUids.contains(postObservableModel.posterUid) && !userModel.user.blockedUids.contains(postObservableModel.posterUid) &&
                !userModel.user.hiddenPostIDs.contains(postObservableModel.id) {
                self.allPosts.append(postObservableModel)
                if postObservableModel.parentPosts == [] {
                    self.filterlingParentPost.append(postObservableModel)
                }
            }
        }
        self.isLastDocumentLoaded = false
        self.isLoading = false
    }
    
    func refreshConcern(concerns:[Concern], userModel: UserObservableModel) {
        self.concernPosts = []
        for concern in concerns {
            let concernObservableModel = concern.adaptConcernObservableModel()
            if !userModel.user.blockingUids.contains(concernObservableModel.posterUid) &&
                !userModel.user.blockedUids.contains(concernObservableModel.posterUid) &&
                !(concern.posterUid == userModel.user.uid)
            {
                self.concernPosts.append(concernObservableModel)
            }
        }
        self.isConcernLastDocumentLoaded = self.concernPosts.count < 20
    }
    
    func refreshFriendPost(posts:[Post], userModel: UserObservableModel) {
        let friendUids = userModel.user.friendUids
        let uid = userModel.user.uid
        if friendUids.count == 0 {
            self.isLoading = false
            return
        }
        self.friendPosts = []
        self.friendFilterlingParentPost = []
        for post in posts {
            let postObservableModel = post.adaptPostObservableModel()
            if (friendUids.contains(post.posterUid) || uid == post.posterUid) &&
                !userModel.user.hiddenPostIDs.contains(post.id) {
                self.friendPosts.append(postObservableModel)
                if postObservableModel.parentPosts == [] {
                    self.friendFilterlingParentPost.append(postObservableModel)
                }
            }
        }
        self.isFriendDocumentLoaded = false
        self.isLoading = false
    }
    
    func processPosts(posts: [Post], userModel: UserObservableModel) {
        for post in posts {
            let postObservableModel = post.adaptPostObservableModel()
            if !userModel.user.blockingUids.contains(postObservableModel.posterUid) && !userModel.user.blockedUids.contains(postObservableModel.posterUid) &&
                !userModel.user.hiddenPostIDs.contains(postObservableModel.id)
            {
                self.allPosts.append(postObservableModel)
                if postObservableModel.parentPosts == [] {
                    self.filterlingParentPost.append(postObservableModel)
                }
            }
        }
        self.isLastDocumentLoaded = posts.count < 20
    }
    
    func processConcernPosts(concernPosts:[Concern], userModel: UserObservableModel){
        if concernPosts.count < 20 { self.isConcernLastDocumentLoaded = true }
        for concernPost in concernPosts {
            let concernPostObservableModel = concernPost.adaptConcernObservableModel()
            if !userModel.user.blockingUids.contains(concernPost.posterUid) &&
                !userModel.user.blockedUids.contains(concernPost.posterUid) &&
                !(concernPost.posterUid == userModel.user.uid)
            {
                self.concernPosts.append(concernPostObservableModel)
            }
        }
    }
    
    func processFriendPost(posts: [Post], userModel: UserObservableModel) {
        let friendUids = userModel.user.friendUids
        let uid = userModel.user.uid
        for post in posts {
            let postObservableModel = post.adaptPostObservableModel()
            if (friendUids.contains(post.posterUid) || uid == post.posterUid) && !userModel.user.hiddenPostIDs.contains(post.id) {
                self.friendPosts.append(postObservableModel)
                if postObservableModel.parentPosts == [] {
                    self.friendFilterlingParentPost.append(postObservableModel)
                }
            }
        }
        self.isFriendDocumentLoaded = posts.count < 20
    }
    
    func deletePost(postID: String, userModel: UserObservableModel) async {
        do {
            async let _ = self.postService
                .deletePost(postID: postID, userID: userModel.user.uid, fixedPostID: userModel.user.fixedPost)
            self.allPosts = self.allPosts.filter { $0.id != postID }
            self.friendPosts =  self.friendPosts.filter { $0.id != postID }
            self.isDeleteToast = true
        } catch {
            self.handle(error: error)
        }
    }
    
    func pinnedPost(postID: String, userID: String) async {
        do {
            try await self.userService.fixedPostToProfile(postID: postID, userID: userID)
        } catch {
            self.handle(error: error)
        }
    }
    
    func hiddenPost(postID: String, userModel: UserObservableModel) async {
        do {
            try await self.userService.addHiddenPost(userID: userModel.user.uid, postID: postID)
            self.allPosts = self.allPosts.filter { $0.id != postID }
            self.friendPosts = self.friendPosts.filter { $0.id != postID }
            self.isHiddenToast = true
        } catch {
            handle(error: error)
        }
    }
    
    func getConcurrentUserInfo(userIDs: [String]) async {
        do {
            let users = try await self.userService.getConcurrentUserInfo(userIDs: userIDs)
            self.friendUsers = users.map { .init(userModel: $0.adaptUserObservableModel()) }
        } catch {
            self.handle(error: error)
        }
    }
}
