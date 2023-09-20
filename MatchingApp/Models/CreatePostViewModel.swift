//
//  CreatePostViewModel.swift
//  MovieShare
//
//  Created by Rio Nagasaki on 2023/07/25.
//

import Foundation
import SwiftUI
import Combine

class CreatePostViewModel: ObservableObject {
    @Published var text: String = ""
    @Published var isLoading: Bool = false
    @Published var isImagePickerModal: Bool = false
    @Published var isCameraModal: Bool = false
    @Published var contentImages: [UIImage] = []
    @Published var errorMessage: String = ""
    @Published var isErrorAlert: Bool = false
    @Published var isPostSuccess: Bool = false
    
    private let postService = PostFirestoreService()
    private var cancellable = Set<AnyCancellable>()
    private let imageStorageManager = ImageStorageManager.init()
    
    func addPost(userModel: UserObservableModel){
        self.isLoading = true
        imageStorageManager.uploadMultipleImageToStorage(
            folderName: "Post",
            images: contentImages
        )
        .flatMap { imageStrings in
            return self.postService.createPost(
                createdAt: Date.init(),
                posterUid: userModel.user.uid,
                posterNickName: userModel.user.nickname,
                posterProfileImageUrlString: userModel.user.profileImageURLString,
                text: self.text,
                contentImageUrlStrings: imageStrings
            )
        }
        .sink { completion in
            switch completion {
            case .finished:
                self.isPostSuccess = true
                self.isLoading = false
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
