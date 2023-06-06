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
    
    @Published var currentUserID: String = ""
    @Published var userID: String = ""
    @Published var nickname: String = ""
    @Published var profileImageURL: String = ""
    @Published var birthDate: String = ""
    @Published var activeRegion: String = ""
    
    func pairSearch(){
        FetchFromFirestore().fetchUserInfoFromFirestoreByUserID(uid: searchedUserId) { user in
            if let user = user {
                self.currentUserID = Authentication().currentUid
                self.userID = user.id
                self.nickname = user.nickname
                self.profileImageURL = user.profileImageURL
                self.birthDate = user.birthDate
                self.activeRegion = user.activityRegion
                self.isModal = true
            } else {
                self.noResult = true
            }
        }
    }
}
