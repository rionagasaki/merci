//
//  Storage.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/25.
//

import Foundation
import UIKit
import FirebaseStorage


final class ImageStorageManager {
    private let storage = Storage.storage()
    private let childName: String = "post"
    private let compressionQuality = 0.3
    
    func uploadImageToStorage(with profileImage: UIImage) async throws -> String {
        guard let updateImage = profileImage.jpegData(compressionQuality: self.compressionQuality) else {
            throw AppError.other(.unexpectedError)
        }
        
        let userProfileRef = self.storage.reference().child(self.childName).child(UUID().uuidString)
        try await withCheckedThrowingContinuation { continuation in
            userProfileRef.putData(updateImage, metadata: nil){ result in
                switch result {
                case .success(_):
                    continuation.resume()
                case .failure(let failure):
                    continuation.resume(with: .failure(failure))
                }
                
            }
        }
        let downloadUrl = try await userProfileRef.downloadURL()
        return downloadUrl.absoluteString
    }
    
    func uploadMultipleImageToStorage(with images:[UIImage]) async throws -> [String] {
        var uploadedImageURLs:[String] = Array(repeating: "", count: images.count)
        
        try await withThrowingTaskGroup(of: (Int, String).self) { [weak self] group in
            guard let self = self else { return }
            for (index, image) in images.enumerated() {
                group.addTask {
                    return (index, try await self.uploadImageToStorage(with: image))
                }
            }
            
            for try await (index, imageURL) in group {
                uploadedImageURLs[index] = imageURL
            }
        }
        return uploadedImageURLs
    }
}
