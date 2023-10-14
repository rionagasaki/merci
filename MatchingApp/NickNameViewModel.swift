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
    
    func storeUserNickname(uid: String) async {
        do {
            try await self.userService.updateUserInfo(
                currentUid: uid,
                key: "nickname",
                value: self.nickname)
        } catch let error as AppError {
            self.errorMessage = error.errorMessage
            self.isErrorAlert = true
        } catch {
            self.errorMessage = error.localizedDescription
            self.isErrorAlert = true
        }
    }
    
}
