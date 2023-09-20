//
//  NickNameViewModel.swift
//  Merci
//
//  Created by Rio Nagasaki on 2023/09/17.
//

import Foundation
import SwiftUI
import Combine

class NickNameViewModel: ObservableObject {
    @Published var nickname: String = ""
    @Published var isErrorAlert: Bool = false
    @Published var errorMessage: String = ""
    @Published var isSuccessStore: Bool = false
    private let userService = UserFirestoreService()
    private var cancellabel = Set<AnyCancellable>()
    
    func storeUserNickname(uid: String){
        self.userService.updateUserInfo(
            currentUid: uid,
            key: "nickname",
            value: self.nickname)
        .sink { completion in
            switch completion {
            case .finished:
                self.isSuccessStore = true
            case .failure(let error):
                self.isErrorAlert = true
                self.errorMessage = error.errorMessage
            }
        } receiveValue: { _ in }
            .store(in: &self.cancellabel)
    }
    
}
