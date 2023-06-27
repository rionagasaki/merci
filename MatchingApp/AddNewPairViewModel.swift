//
//  AddNewPairViewModel.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/05.
//

import Foundation

class AddNewPairViewModel: ObservableObject {
    @Published var searchedUserId: String = ""
    @Published var isModal: Bool = false
    
    @Published var noResult: Bool = false
    @Published var user: UserObservableModel = .init()
    
    func pairSearch(){
        FetchFromFirestore().fetchUserInfoFromFirestoreByUserID(uid: searchedUserId) { user in
            if let user = user {
                self.user = user.adaptUserObservableModel()
                self.searchedUserId = ""
                self.isModal = true
            } else {
                self.noResult = true
            }
        }
    }
}
