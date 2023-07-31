//
//  ProfileImageChangeViewModel.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/07/02.
//

import Foundation
import SwiftUI
import Combine

enum ImageSheetItem: Identifiable {
    case mainImage
    case subImages
    var id: Int {
        hashValue
    }
}

class ProfileImageChangeViewModel: ObservableObject {
    
    let tabSections =  ["メイン(必須)","サブ"]
    
    @Published var selectedImage: UIImage?
    @Published var subImages: [UIImage] = []
    @Published var subImageIndex: Int = 0
    @Published var allImages:[UIImage] = []
    @Published var selection: Int = 0
    @Published var isErrorAlert: Bool = false
    @Published var errorMessage: String = ""
    @Published var previewImagePresented: Bool = false
    @Published var sheetItem: ImageSheetItem?
    let imageCache = NSCache<NSString, UIImage>()
    
    var registerButtonEnabled: Bool {
        selectedImage != nil
    }

    private let imageStorageManager = ImageStorageManager()
    private let setToFirestore = SetToFirestore()
    
    var cancellble = Set<AnyCancellable>()

    func uploadImages(userModel: UserObservableModel, pairModel: PairObservableModel, completion: @escaping (Result<Void, AppError>) -> Void) {
        guard let selectedImage = selectedImage else { return }

        imageStorageManager.uploadImageToStorage(folderName: "UserProfile", profileImage: selectedImage)
            .flatMap { profileImageURLString -> AnyPublisher<[String], AppError> in
                userModel.user.profileImageURL = profileImageURLString
                return self.imageStorageManager.uploadMultipleImageToStorage(folderName: "SubImages", images: self.subImages)
            }
            .flatMap { subImageStrings in
                userModel.user.subProfileImageURL = subImageStrings
                return self.setToFirestore.updateProfileImages(currentUser: userModel, pair: pairModel)
            }
            .sink { result in
                switch result {
                case .finished:
                    completion(.success(()))
                case .failure(let error):
                    completion(.failure(error))
                }
            } receiveValue: { _ in
                print("recieveValue")
            }
            .store(in: &cancellble)
    }

    func getImageFromURLString(urlString: String, completion: @escaping (Result<UIImage, AppError>) -> Void) {
        
        if let cacheImage = imageCache.object(forKey: urlString as NSString){
            completion(.success(cacheImage))
            return
        }
        
        guard let url = URL(string: urlString) else {
            completion(.failure(.other(.invalidUrl)))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(.other(.netWorkError)))
                } else if let data = data, let image = UIImage(data: data) {
                    self.imageCache.setObject(image, forKey: urlString as NSString)
                    completion(.success(image))
                } else {
                    completion(.failure(.other(.unexpectedError)))
                }
            }
        }
        task.resume()
    }

    func setupInitialImages(userModel: UserObservableModel) {
        getImageFromURLString(urlString: userModel.user.profileImageURL) { result in
            switch result {
            case .success(let image):
                self.selectedImage = image
            case .failure(let error):
                self.isErrorAlert = true
                self.errorMessage = error.errorMessage
            }
        }
        
        userModel.user.subProfileImageURL.forEach { urlString in
            getImageFromURLString(urlString: urlString) { result in
                switch result {
                case .success(let image):
                    self.subImages.append(image)
                case .failure(let error):
                    self.isErrorAlert = true
                    self.errorMessage = error.errorMessage
                }
            }
        }
    }
}
