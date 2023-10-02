//
//  CreatePostViewModel.swift
//  MovieShare
//
//  Created by Rio Nagasaki on 2023/07/25.
//

import Foundation
import SwiftUI
import UIKit
import Combine
import PhotosUI

@MainActor
final class CreatePostViewModel: ObservableObject {
    @Published var text: String = ""
    @Published var isLoading: Bool = false
    @Published var isImagePickerModal: Bool = false
    @Published var isCameraModal: Bool = false
    @Published var contentImages: [UIImage] = []
    @Published var errorMessage: String = ""
    @Published var isErrorAlert: Bool = false
    @Published var isPostSuccess: Bool = false
    @Published var isAuthorization: Bool = false
    @Published var photoPickerItem: [PhotosPickerItem] = []
    @Published var isPhotoAutorization: Bool = false
    
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
        .sink { [weak self] completion in
            guard let weakSelf = self else { return }
            switch completion {
            case .finished:
                weakSelf.isPostSuccess = true
                weakSelf.isLoading = false
            case .failure(let error):
                weakSelf.isErrorAlert = true
                weakSelf.errorMessage = error.errorMessage
            }
        } receiveValue: { _ in }
        .store(in: &self.cancellable)
    }
    
func photoPickerChanged(photoPickerItems: [PhotosPickerItem]) async throws {
        self.contentImages = []
        for photoPickerItem in photoPickerItems {
            do {
                if let data = try await photoPickerItem.loadTransferable(type: Data.self) {
                    if let uiImage = UIImage(data: data) {
                        self.contentImages.append(uiImage)
                    }
                }
            } catch {
                throw error
            }
        }
    }
}
