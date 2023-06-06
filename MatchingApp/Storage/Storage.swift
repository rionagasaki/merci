//
//  Storage.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/25.
//

import Foundation
import UIKit
import FirebaseStorage

let storage = Storage.storage()
class RegisterStorage {
    
    let dispatchGroup = DispatchGroup()
    
    func registerImageToStorage(folderName: String,profileImage: UIImage,completion: @escaping (String)-> Void){
        guard let updateImage = profileImage.jpegData(compressionQuality: 0.3) else { return }
        let fileName = NSUUID().uuidString
        let userProfileRef = storage.reference().child(folderName).child(fileName)
        userProfileRef.putData(updateImage, metadata: nil) { metadata, error in
            if error != nil {
                print((error?.localizedDescription).orEmpty)
                return
            }
            guard metadata != nil else {
                return
            }
            userProfileRef.downloadURL { url, error in
                guard let downloadURL = url else {
                    return
                }
                completion(downloadURL.absoluteString)
            }
        }
    }
    
    func registerConcurrentImageToStorage(folderName: String, images:[UIImage], completion: @escaping ([String]) -> Void){
        var registerImageURLs:[String] = []
        for image in images {
            dispatchGroup.enter()
            registerImageToStorage(folderName: folderName, profileImage: image) { urlString in
                registerImageURLs.append(urlString)
                self.dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .main){
            completion(registerImageURLs)
        }
    }
}
