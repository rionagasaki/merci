//
//  FetchFromFirestore.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/23.
//

import Foundation
import FirebaseFirestore

let db = Firestore.firestore()

class FetchFromFirestore {
    
    let userPath = "User"
    
    func fetchUserInfoFromFirestore(completion: @escaping (User)-> Void){
        
        db.collection(userPath).document(Authentication().currentUid).getDocument { document, error in
            if let error = error {
                print("Error=>fetchUserInfoFromFirestore:\(error)")
                return
            }
            guard let document = document else { return }
            let docRef = User(document: document)
            print(docRef.activityRegion)
            completion(docRef)
        }
    }
}
