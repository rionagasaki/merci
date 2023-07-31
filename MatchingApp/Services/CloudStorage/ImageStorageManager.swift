//
//  Storage.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/25.
//

import Foundation
import UIKit
import FirebaseStorage
import Combine


class ImageStorageManager {
    let storage = Storage.storage()
    var cancellable = Set<AnyCancellable>()
    func uploadImageToStorage(folderName: String,profileImage: UIImage) -> AnyPublisher<String, AppError> {
        Future { promise in
            guard let updateImage = profileImage.jpegData(compressionQuality: 0.3) else {
                return promise(.failure(.other(.changeJpegError)))
            }
            let fileName = NSUUID().uuidString
            let userProfileRef = self.storage.reference().child(folderName).child(fileName)
            userProfileRef.putData(updateImage, metadata: nil) { metadata, error in
                if let error = error as? NSError {
                    return promise(.failure(.storage(error)))
                }
                userProfileRef.downloadURL { url, error in
                    if let error = error as? NSError {
                        promise(.failure(.storage(error)))
                    } else if let downloadURL = url {
                        promise(.success(downloadURL.absoluteString))
                    }
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func uploadMultipleImageToStorage(folderName: String, images:[UIImage]) -> AnyPublisher<[String], AppError> {
        let uploadFutures = images.map { uploadImageToStorage(folderName: folderName, profileImage: $0) }
        let mergedFutures = Publishers
            .MergeMany(uploadFutures)
            .eraseToAnyPublisher()
            .collect()
            
        let futureResult = Future<[String], AppError> { promise in
            mergedFutures
                .sink { completion in
                    switch completion {
                    case .finished:
                        break
                    case let .failure(error):
                        promise(.failure(error))
                    }
                } receiveValue: { images in
                    print(images)
                    promise(.success(images))
                }
                .store(in: &self.cancellable)
        }.eraseToAnyPublisher()
        return futureResult
    }
}
