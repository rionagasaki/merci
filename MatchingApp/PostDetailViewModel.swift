//
//  PostDetailViewModel.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/08/11.
//

import Foundation
import Combine

class PostDetailViewModel: ObservableObject {
    @Published var parentPosts: [PostObservableModel] = []
    @Published var selfPost: PostObservableModel?
    @Published var childPosts: [PostObservableModel] = []
    @Published var errorMessage: String = ""
    @Published var isErrorAlert: Bool = false
    @Published var isPostSuccess: Bool = false
    @Published var isLoading: Bool = false
    private var postService = PostFirestoreService()
    private var fetchFromFirestore = FetchFromFirestore()
    private var cancellable = Set<AnyCancellable>()
    
    func initial(postId: String){
        self.isLoading = true
        self.postService.getOnePost(postId: postId)
            .flatMap { post in
                let fetchSelfPost = post.adaptPostObservableModel()
                let allRelatedPostIds = fetchSelfPost.parentPosts + fetchSelfPost.childPosts
                self.selfPost = post.adaptPostObservableModel()
                return self.postService.getPostsConcurrentlly(postIds: allRelatedPostIds)
            }
            .sink { completion in
                switch completion {
                case .finished:
                    self.isPostSuccess = true
                case .failure(let error):
                    self.isErrorAlert = true
                    self.errorMessage = error.errorMessage
                }
            } receiveValue: { posts in
                guard let selfPost = self.selfPost else { return }
                self.childPosts = []
                self.parentPosts = []
                for post in posts {
                    if selfPost.childPosts.contains(post.id) {
                        self.childPosts.append(post.adaptPostObservableModel())
                    }
                    
                    if selfPost.parentPosts.contains(post.id) {
                        self.parentPosts.append(post.adaptPostObservableModel())
                    }
                }
                self.isLoading = false
            }
            .store(in: &self.cancellable)
    }
}
