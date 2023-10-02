//
//  ProfileImageOnboardingViewModel.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/07/10.
//
import Foundation
import Combine
import SwiftUI

class ProfileImageInitViewModel: ObservableObject {
    
    private var cancellable = Set<AnyCancellable>()
    private let imageStorageManager = ImageStorageManager()
    private let userService = UserFirestoreService()
    @Published var selectedHobbies: [String] = []
    @Published var isSuccessRegister: Bool = false
    @Published var isErrorAlert: Bool = false
    @Published var errorMessage: String = ""
    
    func completeRegister(userModel: UserObservableModel, appState: AppState, completionHandler:@escaping () -> Void){
        self.userService.createUser(userInfo: userModel){ result in
            switch result {
            case .success(_):
                completionHandler()
            case .failure(let error):
                self.errorMessage = error.errorMessage
                self.isErrorAlert = true
            }
        }
    }
}

