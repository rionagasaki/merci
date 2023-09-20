//
//  PostViewModel.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/08/08.
//

import Foundation
import Combine

class PostViewModel: ObservableObject {
    @Published var text: String = ""
    @Published var errorMessage: String = ""
    @Published var isErrorAlert: Bool = false
    @Published var isPostSuccess: Bool = false
    @Published var isLiked: Bool = false
    @Published var isLikedNum: Int = 0
    @Published var isNeededReload: Bool = false
    @Published var isReplyModal: Bool = false
    @Published var isParticle: Bool = false
    private let postService = PostFirestoreService()
    private var cancellable = Set<AnyCancellable>()
    
    func initial(userModel: UserObservableModel, post: PostObservableModel){
        self.isLiked = post.likes.keys.contains(userModel.user.uid)
        self.isLikedNum = post.likes.keys.count
    }
    
    func handleLikeButtonPress(userModel: UserObservableModel, postModel: PostObservableModel){
        self.postService
            .handleLikeButtonPress(userModel: userModel, postModel: postModel)
            .sink { completion in
                switch completion {
                case .finished:
                    self.isLiked.toggle()
                    if self.isLiked {
                        self.isParticle = true
                        self.isLikedNum += 1
                    } else {
                        self.isLikedNum -= 1
                    }
                case .failure(let error):
                    self.isErrorAlert = true
                    self.errorMessage = error.errorMessage
                }
            } receiveValue: { _ in }
            .store(in: &self.cancellable)
    }
    
    func deletePost(postID: String) {
        self.postService
            .deletePost(postID: postID)
            .sink { completion in
                switch completion {
                case .finished:
                    self.isLiked.toggle()
                case .failure(let error):
                    self.isErrorAlert = true
                    self.errorMessage = error.errorMessage
                }
            } receiveValue: { _ in
                print("recieve value")
            }
            .store(in: &self.cancellable)
    }
    
    func pinnedPost() {
        
    }
}
