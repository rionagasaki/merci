//
//  SetToFirestore.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/23.
//

import Foundation
import FirebaseFirestore

class SetToFirestore {
    
    static let shared = SetToFirestore()
    private init(){}
    
    func registerUserInfoFirestore(uid: String, nickname: String, email: String,gender:String,activityRegion: String, birthDate: String, completion: @escaping ()-> Void){
        db.collection("User").document(uid).setData([
            "nickname": nickname,
            "email": email,
            "profileImageURL": "https://firebasestorage.googleapis.com/v0/b/marketsns.appspot.com/o/UserProfile%2Furban-user-3.png?alt=media&token=94166887-d8d6-4ab6-9a01-457a774ed51c",
            "gender": gender,
            "activityRegion": activityRegion,
            "birthDate": birthDate
        ]){ err in
            if let err = err {
                print("Error=>registerUserInfoFirestore:\(String(describing: err))")
            } else {
                completion()
            }
        }
    }
}
