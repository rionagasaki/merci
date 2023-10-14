//
//  UserIntroductionEditorViewModel.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/07/04.
//

import Foundation
import SwiftUI
import Combine

class UserIntroductionEditorViewModel: ObservableObject {
    @Published var userIntroduction: String = ""
    @Published var isErrorAlert: Bool = false
    @Published var errorMessage: String = ""
    @Published var isSuccess: Bool = false
    private let userService = UserFirestoreService()
    
    func storeUserIntroductionToFirestore(
        userModel: UserObservableModel
    ) async {
        do {
            try await self.userService.updateUserInfo(currentUid: userModel.user.uid, key: "introduction", value: self.userIntroduction)
            self.isSuccess = true
        } catch let error as AppError {
            self.errorMessage = error.errorMessage
            self.isErrorAlert = true
        } catch {
            self.errorMessage = error.localizedDescription
            self.isErrorAlert = true
        }
    }
}
