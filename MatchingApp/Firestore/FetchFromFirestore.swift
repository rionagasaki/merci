//
//  FetchFromFirestore.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/23.
//

import Foundation
import FirebaseFirestore
import Firebase

let db = Firestore.firestore()

class FetchFromFirestore {
    
    let userPath = "User"
    let pairPath = "Pair"
    let chatPath = "Chat"
    let messagePath = "Message"
    var listener: ListenerRegistration? = nil
    var pairListener: ListenerRegistration? = nil
    var chatListener: ListenerRegistration? = nil
    
    let dispatchGroup = DispatchGroup()

    func fetchUserInfoFromFirestore(completion: @escaping (User)-> Void){
        guard let uid = AuthenticationManager.shared.uid else { return }
        db.collection(userPath).document(uid).getDocument(source: .cache) { document, error in
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
    
    func fetchPairInfo(completion: @escaping ([Pair])-> Void){
        pairListener?.remove()
        pairListener = db.collection(pairPath).addSnapshotListener { querySnapshots, error in
            var pairs:[Pair]
            if let error = error {
                print("Error=>fetchUserInfoFromFirestore:\(error)")
                return
            }
            
            guard let querySnapshots = querySnapshots else { return }
            
            pairs = querySnapshots.documentChanges.compactMap({ diff in
                if (diff.type == .added){
                    let pairDoc = Pair(document: diff.document)
                    return pairDoc
                } else {
                    return nil
                }
            })
            completion(pairs)
        }
    }
    
    func fetchSnapshotPairInfo(pairID: String ,completion: @escaping(Pair)-> Void){
        if pairID == "" { return }
        db
            .collection(self.pairPath)
            .document(pairID)
            .addSnapshotListener{ document, error in
                if let error = error {
                    print("Error=>fetchUserInfoFromFirestore:\(error)")
                    return
                }
                print("キャッシュ！！",document?.metadata.isFromCache)
                guard let document = document else { return}
                let pairDoc = Pair(document: document)
                completion(pairDoc)
            }
    }
    
    func fetchPairInfo(pairID: String ,completion: @escaping(Pair)-> Void){
        if pairID == "" { return }
        db
            .collection(self.pairPath)
            .document(pairID)
            .getDocument { document, error in
                if let error = error {
                    print("Error=>fetchUserInfoFromFirestore:\(error)")
                    return
                }
                guard let document = document else { return}
                let pairDoc = Pair(document: document)
                completion(pairDoc)
            }
    }
    
    func fetchConcurrentUserInfo(userIDs: [String], completion: @escaping ([User]) -> Void){
        var usersInfoArray:[User] = []
        for userID in userIDs {
            dispatchGroup.enter()
            fetchUserInfoFromFirestoreByUserID(uid: userID) { user in
                guard let user = user else { return }
                usersInfoArray.append(user)
                self.dispatchGroup.leave()
            }
        }
        dispatchGroup.notify(queue: .main){
            completion(usersInfoArray)
        }
    }
    
    func fetchConcurrentPairInfo(pairIDs: [String], completion: @escaping ([Pair]) -> Void) {
        var pairsInfoArray:[Pair] = []
        for pairID in pairIDs {
            dispatchGroup.enter()
            fetchPairInfo(pairID: pairID) { pair in
                pairsInfoArray.append(pair)
                self.dispatchGroup.leave()
            }
        }
        
        dispatchGroup.notify(queue: .main){
            completion(pairsInfoArray)
        }
    }
    
    func fetchUserInfoFromFirestoreByUserID(uid: String, completion: @escaping (User?)-> Void){
        db.collection(userPath).document(uid).getDocument { document, error in
            if let error = error {
                print("Error=>fetchUserInfoFromFirestore:\(error)")
                return
            }
            
            guard let document = document else { return }
            if document.exists {
                let docRef = User(document: document)
                completion(docRef)
            } else {
                completion(nil)
            }
        }
    }
    
    func snapshotOnRequest(uid: String, completion: @escaping (User)-> Void){
        listener?.remove()
        listener = db.collection(userPath).document(uid).addSnapshotListener { document, error in
            guard let document = document else {
                print("Error \(String(describing: error))")
                return
            }
            let docRef = User(document: document)
            completion(docRef)
        }
    }
    
    func deleteListener(){
        listener?.remove()
    }
    
    func snapshotOnChat(chatroomID:String, completion: @escaping(Chat) -> Void) {
        listener?.remove()
        listener = db
            .collection(chatPath)
            .document(chatroomID)
            .collection(messagePath)
            .order(by: "createdAt")
            
            .addSnapshotListener { querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            snapshot.documentChanges.forEach { diff in
                if (diff.type == .added) {
                    let docRef = Chat(document: diff.document)
                    completion(docRef)
                }
                if (diff.type == .modified) {
                    let docRef = Chat(document: diff.document)
                    completion(docRef)
                }
                if (diff.type == .removed) {
                    print("Removed city: \(diff.document.data())")
                }
            }
        }
    }
}
