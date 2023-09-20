//
//  CreateReplyPostViewModel.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/08/11.
//

import Foundation
import UIKit
import Combine

class CreateReplyPostViewModel: ObservableObject {
    @Published var text: String = ""
    @Published var toUser: UserObservableModel?
    @Published var isImagePickerModal: Bool = false
    @Published var isLoading: Bool = false
    @Published var isCameraModal: Bool = false
    @Published var contentImages: [UIImage] = []
    @Published var errorMessage: String = ""
    @Published var isErrorAlert: Bool = false
    @Published var isPostSuccess: Bool = false
    private var userService = UserFirestoreService()
    private let postService = PostFirestoreService()
    private var cancellable = Set<AnyCancellable>()
    private let imageStorageManager = ImageStorageManager.init()
    
    
    func initial(uid: String){
        self.userService
            .getUser(uid: uid)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("finished")
                case .failure(let error):
                    self.isErrorAlert = true
                    self.errorMessage = error.errorMessage
                }
            }, receiveValue: { user in
                self.toUser = .init(userModel: user)
            })
            .store(in: &self.cancellable)
    }
    
    func addPost(post: PostObservableModel, fromUser: UserObservableModel){
        self.isLoading = true
        if text.isEmpty {
            self.isErrorAlert = true
            self.errorMessage = "テキストは必須です。"
            return
        }
        
        guard let toUser = toUser else {
            self.isErrorAlert = true
            self.errorMessage = "ユーザー情報の取得に失敗しました"
            return
        }
        
        imageStorageManager.uploadMultipleImageToStorage(
            folderName: "Post",
            images: contentImages
        )
        .flatMap { imageStrings in
            return self.postService.createReplyPost(
                fromUser: fromUser,
                toUser: toUser,
                parentPost: post,
                text: self.text,
                contentImageUrlStrings: imageStrings
            )
        }
        .sink { completion in
            switch completion {
            case .finished:
                self.isLoading = false
                self.isPostSuccess = true
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
