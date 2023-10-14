//
//  CreatePostViewModel.swift
//  MovieShare
//
//  Created by Rio Nagasaki on 2023/07/25.
//

import Foundation
import SwiftUI
import Combine
import PhotosUI

@MainActor
final class CreatePostViewModel: ObservableObject {
    @Published var text: String = ""
    @Published var isCreateConcerAlert: Bool = false
    @Published var isLoading: Bool = false
    @Published var isImagePickerModal: Bool = false
    @Published var isCameraModal: Bool = false
    @Published var contentImages: [UIImage] = []
    @Published var errorMessage: String = ""
    @Published var isErrorAlert: Bool = false
    @Published var isPostSuccess: Bool = false
    @Published var isAuthorization: Bool = false
    @Published var isConcern: Bool = false
    @Published var concernKind: ConcernKind? = nil
    @Published var photoPickerItem: [PhotosPickerItem] = []
    @Published var isPhotoAutorization: Bool = false
    
    private let postService = PostFirestoreService()
    private let concernService = ConcernFirestoreService()
    private let imageStorageManager = ImageStorageManager.init()
    
    private func handleError(error: Error) {
        if let error = error as? AppError {
            self.errorMessage = error.errorMessage
        } else {
            self.errorMessage = error.localizedDescription
        }
        self.isErrorAlert = true
    }
    
    func addPost(userModel: UserObservableModel) async {
        do {
            self.isLoading = true
            let downloadImageUrlStrings = try await self.imageStorageManager.uploadMultipleImageToStorage(with: self.contentImages)
            try await self.postService.createPost(
                createdAt: Date.init(),
                posterUid: userModel.user.uid,
                posterNickName: userModel.user.nickname,
                posterProfileImageUrlString: userModel.user.profileImageURLString,
                text: self.text,
                contentImageUrlStrings: downloadImageUrlStrings
            )
            self.isPostSuccess = true
            self.isLoading = false
        } catch {
            self.handleError(error: error)
        }
    }
    
    func addConcernPost(user: UserObservableModel) async {
        do {
            self.isLoading = true
            if let category = concernKind?.category {
                try await concernService.addConcernPost(
                    text: self.text,
                    kind: category.name,
                    image: category.imageName,
                    posterUser: user
                )
            }
            self.isCreateConcerAlert = true
            self.isLoading = false
        } catch let error as AppError {
            self.errorMessage = error.errorMessage
            self.isErrorAlert = true
        } catch {
            self.errorMessage = error.localizedDescription
            self.isErrorAlert = true
        }
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
