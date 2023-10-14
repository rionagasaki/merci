//
//  UserProfileViewModel.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/26.
//

import Foundation
import Combine

class UserProfileViewModel: ObservableObject {
    @Published var user: UserObservableModel?
    @Published var isErrorAlert: Bool = false
    @Published var errorMessage: String = ""
    @Published var isReportAbuseModal: Bool = false
    @Published var isAlert: Bool = false
    @Published var isLastDocumentLoaded: Bool = false
    @Published var isCompleteToast: Bool = false
    @Published var fixedPost: PostObservableModel?
    @Published var usersPost: [PostObservableModel] = []
    @Published var isDeleteAccount: Bool = false
    @Published var isLoading: Bool = false
    
    private let userService = UserFirestoreService()
    private let postService = PostFirestoreService()
    private var cancellable = Set<AnyCancellable>()
    
    private func handleError(error: Error) {
        if let error = error as? AppError {
            self.errorMessage = error.errorMessage
        } else {
            self.errorMessage = error.localizedDescription
        }
        self.isErrorAlert = true
    }
    
    func initial(userId: String){
        if userId.isEmpty { return }
        self.isLoading = true
        self.userService
            .getUser(uid: userId)
            .flatMap { user -> AnyPublisher<[Post], AppError> in
                if user.nickname.isEmpty {
                    self.isDeleteAccount = true
                    return Empty().setFailureType(to: AppError.self).eraseToAnyPublisher()
                }
                self.user = .init(userModel: user)
                return self.postService.getUserPost(userID: user.uid)
            }
            .sink { completion in
                switch completion {
                case .finished:
                    print("finished")
                case .failure(let error):
                    self.isErrorAlert = true
                    self.errorMessage = error.errorMessage
                }
            } receiveValue: { posts in
                self.usersPost = []
                if let user = self.user {
                    let fixedPostArr = posts.filter({ $0.id == user.user.fixedPost })
                    if fixedPostArr.count != 0 {
                        self.fixedPost = fixedPostArr[0].adaptPostObservableModel()
                    }
                }
                if posts.count < 20 {
                    self.isLastDocumentLoaded = true
                } else {
                    self.isLastDocumentLoaded = false
                }
                self.processPosts(posts: posts)
            }
            .store(in: &self.cancellable)
    }
    
    func getLatestPosts() {
        guard let user = user else { return }
        self.postService.getUserPost(userID: user.user.uid)
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
                } else {
                    self.isLastDocumentLoaded = false
                }
                self.refreshPost(posts: posts)
            }
            .store(in: &self.cancellable)
    }
    
    func getNextPage(userID: String) {
        self.postService.getNextUsersPost(userId: userID)
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
                self.processPosts(posts: posts)
            }
            .store(in: &self.cancellable)
    }
    
    func processPosts(posts: [Post]) {
        for post in posts {
            let postObservableModel = post.adaptPostObservableModel()
            
            self.usersPost.append(postObservableModel)
        }
        self.isLoading = false
    }
    
    func refreshPost(posts: [Post]) {
        self.usersPost = []
        for post in posts {
            let postObservableModel = post.adaptPostObservableModel()
            self.usersPost.append(postObservableModel)
        }
        self.isLoading = false
    }
    
    func createPairRequest(requestingUser: UserObservableModel, requestedUser: UserObservableModel){
        self.userService
            .requestFriend(requestingUser: requestingUser, requestedUser: requestedUser)
            .sink { completion in
                switch completion {
                case .finished:
                    print("finished")
                case .failure(let error):
                    self.isErrorAlert = true
                    self.errorMessage = error.errorMessage
                }
            } receiveValue: { _ in
                print("revieve value")
            }
            .store(in: &self.cancellable)
    }
    
    func deletePost(postID: String, userModel: UserObservableModel) async {
        do {
            try await self.postService
                .deletePost(postID: postID, userID: userModel.user.uid, fixedPostID: userModel.user.fixedPost)
            if postID == self.fixedPost?.id {
                self.fixedPost = nil
            }
            self.getLatestPosts()
        } catch let error as AppError {
            self.errorMessage = error.errorMessage
            self.isErrorAlert = true
        } catch {
            self.errorMessage = error.localizedDescription
            self.isErrorAlert = true
        }
        
    }
    
    func pinnedPost(postID: String, userID: String) async {
        do {
            try await self.userService.fixedPostToProfile(postID: postID, userID: userID)
            if postID.isEmpty {
                self.fixedPost = nil
            } else {
                self.getPost(postID: postID)
            }
        } catch {
            self.handleError(error: error)
        }
    }
    
    func getPost(postID: String){
        self.postService.getOnePost(postId: postID)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.errorMessage = error.errorMessage
                    self.isErrorAlert = true
                }
            } receiveValue: { post in self.fixedPost = post.adaptPostObservableModel() }.store(in: &self.cancellable)
    }
}
