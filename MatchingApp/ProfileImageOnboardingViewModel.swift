//
//  ProfileImageOnboardingViewModel.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/07/10.
//
import Foundation
import Combine
import SwiftUI

class ProfileImageOnboardingViewModel: ObservableObject {
    
    private var cancellable = Set<AnyCancellable>()
    let imageStorageManager = ImageStorageManager()
    let setToFirestore = SetToFirestore()
    let fetchFromFirestore = FetchFromFirestore()
    @Published var isLoading: Bool = false
    @Published var selectedImage: UIImage?
    @Published var subImages:[UIImage] = []
    @Published var allImages:[UIImage] = []
    @Published var subImageIndex: Int = 0
    
    
    func completeRegister(userModel: UserObservableModel, appState: AppState){
        guard let selectedImage = selectedImage else { return }
        imageStorageManager.uploadImageToStorage(folderName: "UserProfile", profileImage: selectedImage)
            .flatMap { imageURLString -> AnyPublisher<[String], AppError> in
                userModel.user.profileImageURL = imageURLString
                guard let uid = AuthenticationManager.shared.uid else {
                    return Empty(completeImmediately: true).eraseToAnyPublisher()
                }
                guard let email = AuthenticationManager.shared.email else {
                    return Empty(completeImmediately: true).eraseToAnyPublisher()
                }
                userModel.user.uid = uid
                userModel.user.email = email
                return self.imageStorageManager.uploadMultipleImageToStorage(folderName: "SubImages", images: self.subImages)
            }
            .flatMap { subImageURLStrings in
                userModel.user.subProfileImageURL = subImageURLStrings
                return self.setToFirestore.registerInitialUserInfoToFirestore(userInfo: userModel)
            }
            .flatMap { _ in
                return self.fetchFromFirestore.monitorUserUpdates(uid: userModel.user.uid)
            }
            .sink { completion in
                switch completion {
                case .finished:
                    print("ここは呼ばれん")
                case let .failure(error):
                    print(error)
                }
            } receiveValue: { user in
                userModel.user = user.adaptUserObservableModel()
                appState.notLoggedInUser = false
                self.isLoading = true
            }
            .store(in: &self.cancellable)
    }
}

