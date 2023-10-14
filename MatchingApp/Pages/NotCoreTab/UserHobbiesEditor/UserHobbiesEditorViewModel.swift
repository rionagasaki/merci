//
//  HobbiesViewModel.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/24.
//

import Foundation
import SwiftUI
import Combine

class UserHobbiesEditorViewModel: ObservableObject {
    @Published var selectedHobbies: [String] = []
    @Published var isSuccess: Bool = false
    @Published var errorMessage: String = ""
    @Published var isErrorAlert: Bool = false
    private var cancellable = Set<AnyCancellable>()
    private let userService = UserFirestoreService()
    
    func storeHobbiesToFirestore(userModel: UserObservableModel) async {
        do {
            try await self.userService.updateUserInfo(
                currentUid: userModel.user.uid,
                key: "hobbies",
                value: self.selectedHobbies)
        } catch let error as AppError {
            self.errorMessage = error.errorMessage
            self.isErrorAlert = true
        } catch {
            self.errorMessage = error.localizedDescription
            self.isErrorAlert = true
        }
    }
}
