//
//  ProfileImageChangeViewModel.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/07/02.
//

import Foundation
import SwiftUI
import Combine

class ProfileImageChangeViewModel: ObservableObject {
    @Published var isSuccessImageUpdate: Bool = false
    @Published var selectedImage: String = ""
    @Published var isErrorAlert: Bool = false
    @Published var errorMessage: String = ""
    
    var registerButtonEnabled: Bool {
        !selectedImage.isEmpty
    }
    
    private let imageStorageManager = ImageStorageManager()
    private let userService = UserFirestoreService()
    
    var cancellble = Set<AnyCancellable>()
    
    func updateUserProfileImage(userModel: UserObservableModel){
        if selectedImage.isEmpty { return }
        userService.updateProfileImageForUser(currentUser: userModel, selectedImage: self.selectedImage)
            .sink { completion in
                switch completion {
                case .finished:
                    self.isSuccessImageUpdate = true
                case .failure(let error):
                    self.errorMessage = error.errorMessage
                    self.isErrorAlert = true
                }
            } receiveValue: { _ in
                print("recieve value")
            }
            .store(in: &self.cancellble)
    }
}
