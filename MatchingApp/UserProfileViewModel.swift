//
//  UserProfileViewModel.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/26.
//

import Foundation

class UserProfileViewModel: ObservableObject {
    
    func pairRequest(currentUserID: String, userID: String){
        SetToFirestore.shared.requestPair(currentUid: currentUserID, pairUserUid: userID)
    }
    
}
