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
    @Published var isFailedStoreData: Bool = false
    private var cancellable = Set<AnyCancellable>()
    private let userService = UserFirestoreService()
    
    func storeHobbiesToFirestore(userModel: UserObservableModel) {
        self.userService.updateUserInfo(
            currentUid: userModel.user.uid,
            key: "hobbies",
            value: self.selectedHobbies)
            .sink { completion in
                switch completion {
                case .finished:
                    self.isSuccess = true
                case .failure(_):
                    self.isFailedStoreData = true
                }
            } receiveValue: { _ in }
            .store(in: &self.cancellable)
    }
}
