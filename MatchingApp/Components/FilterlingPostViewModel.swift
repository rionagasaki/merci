//
//  FilterlingPostViewModel.swift
//  Merci
//
//  Created by Rio Nagasaki on 2023/09/22.
//

import Foundation
import Combine

class FilterlingPostViewModel: ObservableObject {
    
    @Published var isLoading: Bool = false
    @Published var isErrorAlert: Bool = false
    @Published var errorMessage: String = ""
    @Published var isSuccessUpdatePostSetting: Bool = false
    private var cancellable = Set<AnyCancellable>()
    private let userService = UserFirestoreService()
    
    func updateIsDisplayOnlyPost(userID: String, isDisplayOnlyPost: PostFilter, completionHandler: @escaping()->Void){
        self.isLoading = true
        self.userService.updateIsDisplayOnlyPost(userID: userID, isDisplayOnlyPost: isDisplayOnlyPost == .allPosts){ result in
            switch result {
            case .success(_):
                self.isLoading = false
                completionHandler()
            case .failure(let error):
                self.errorMessage = error.errorMessage
                self.isErrorAlert = true
            }
        }
    }
}
