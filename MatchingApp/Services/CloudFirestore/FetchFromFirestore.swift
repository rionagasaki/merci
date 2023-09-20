//
//  FetchFromFirestore.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/23.
//

import Foundation
import FirebaseFirestore
import Firebase
import Combine

let db = Firestore.firestore()

class FetchFromFirestore {
    
    let userPath = "User"
    let postPath = "Post"
    let pairPath = "Pair"
    let chatPath = "Chat"
    let messagePath = "Message"
    let channelPath = "Channel"
    let likeNoticePath = "LikeNotice"
    let commentNoticePath = "CommentNotice"
    let requestNoticePath = "RequestNotice"
    
    let dispatchGroup = DispatchGroup()
    var cancellable = Set<AnyCancellable>()
    
    func deleteUserListener(){
        FirestoreListener.shared.userListener?.remove()
    }
    
    func deleteChatListener(){
        FirestoreListener.shared.chatListener?.remove()
    }
    
    func getDocument(_ docRef: DocumentReference) -> Future<DocumentSnapshot, Error> {
        return Future { promise in
            docRef.getDocument { (document, error) in
                if let error = error {
                    promise(.failure(error))
                } else if let document = document {
                    promise(.success(document))
                }
            }
        }
    }
}
