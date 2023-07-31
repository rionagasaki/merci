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
    private var cancellable = Set<AnyCancellable>()
    let setToFirestore = SetToFirestore()
    
    func storeUserIntroductionToFirestore(
        userModel: UserObservableModel
    ){
        setToFirestore.updateMyIntroduction(currentUid: userModel.user.uid, introduction: self.userIntroduction)
            .sink { completion in
                switch completion {
                case .finished:
                    self.isSuccess = true
                case .failure(let error):
                    self.isErrorAlert = true
                    self.errorMessage = error.errorMessage
                }
            } receiveValue: { _ in
                print("recieve value")
            }
            .store(in: &self.cancellable)
    }
}
