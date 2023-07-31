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
    let pairPath = "Pair"
    let chatPath = "Chat"
    let messagePath = "Message"
    
    let dispatchGroup = DispatchGroup()
    var cancellable = Set<AnyCancellable>()
    
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
    
    func fetchPairInfo(source: FirestoreSource) -> Future<[Pair], AppError>{
        Future { promise in
            db.collection(self.pairPath).getDocuments(source: .server) { querySnapshots, error in
                var pairs:[Pair]
                if let error = error as? NSError {
                    promise(.failure(.firestore(error)))
                    return
                }
                guard let querySnapshots = querySnapshots else { return }
                pairs = querySnapshots.documents.map { Pair(document: $0) }
                promise(.success(pairs))
            }
        }
    }
    
    func monitorUserUpdates(uid: String) -> AnyPublisher<User, AppError> {
        let subject = PassthroughSubject<User, AppError>()
        FirestoreListener.shared.userListener = db.collection(self.userPath).document(uid).addSnapshotListener { document, error in
            if let error = error {
                subject.send(completion: .failure(.firestore(error)))
                return
            }
            guard let document = document else {
                subject.send(completion: .failure(.other(.unexpectedError)))
                return
            }
            subject.send(User(document: document))
        }
        return subject.eraseToAnyPublisher()
    }
    
    func monitorPairInfoUpdate(pairID: String) -> AnyPublisher<Pair, AppError>{
        let subject = PassthroughSubject<Pair, AppError>()
        FirestoreListener.shared.pairListener = db
            .collection(self.pairPath)
            .document(pairID)
            .addSnapshotListener{ document, error in
                if let error = error {
                    subject.send(completion: .failure(.firestore(error)))
                    return
                }
                guard let document = document else {
                    subject.send(completion: .failure(.other(.unexpectedError)))
                    return
                }
                let pairDoc = Pair(document: document)
                subject.send(pairDoc)
            }
        return subject.eraseToAnyPublisher()
    }
    
    func snapshotOnChat(chatroomID:String) -> AnyPublisher<Chat, AppError> {
        let subject = PassthroughSubject<Chat, AppError>()
        FirestoreListener.shared.chatListener = db
            .collection(chatPath)
            .document(chatroomID)
            .collection(messagePath)
            .order(by: "createdAt")
            .addSnapshotListener { querySnapshot, error in
            
                if let error = error {
                    subject.send(completion: .failure(.firestore(error)))
                    return
                }
                
                guard let snapshot = querySnapshot else {
                    subject.send(completion: .failure(.other(.unexpectedError)))
                    return
                }

                snapshot.documentChanges.forEach { diff in
                    if (diff.type == .added) {
                        let docRef = Chat(document: diff.document)
                        subject.send(docRef)
                    }
                    if (diff.type == .modified) {
                        let docRef = Chat(document: diff.document)
                        subject.send(docRef)
                    }
                    if (diff.type == .removed) {
                        print("Removed city: \(diff.document.data())")
                    }
                }
            }
        return subject.eraseToAnyPublisher()
    }
    
    
    func fetchPairInfo(pairID: String) -> AnyPublisher<Pair, AppError> {
        Future { promise in
            if pairID.isEmpty { return }
            db
                .collection(self.pairPath)
                .document(pairID)
                .getDocument { document, error in
                    if let error = error {
                        promise(.failure(.firestore(error)))
                        return
                    }
                    guard let document = document else { return}
                    promise(.success(Pair(document: document)))
                }
        }.eraseToAnyPublisher()
    }
    
    func fetchConcurrentUserInfo(userIDs: [String]) -> AnyPublisher<[User], AppError>{
        let publisher = userIDs.map { fetchUserInfoFromFirestoreByUserID(uid: $0) }
        return Publishers.MergeMany(publisher).compactMap { $0 }.collect().eraseToAnyPublisher()
    }
    
    func fetchConcurrentPairInfo(pairIDs: [String]) -> AnyPublisher<[Pair], AppError> {
        var pairs: [Pair] = []
        let publishers = pairIDs.map { fetchPairInfo(pairID: $0) }
        let mergePublishers = Publishers.MergeMany(publishers).collect()
        return Future { promise in
            mergePublishers.sink { completion in
                switch completion {
                case .finished:
                    promise(.success(pairs))
                case .failure(_):
                    promise(.failure(.other(.netWorkError)))
                }
            } receiveValue: { fetchPairs in
                pairs = fetchPairs
            }
            .store(in: &self.cancellable)
        }.eraseToAnyPublisher()
    }
    
    func fetchUserInfoFromFirestoreByUserID(uid: String) -> AnyPublisher<User?, AppError>{
        return Future { promise in
            if uid.isEmpty {
                promise(.success(nil))
                return
            }
            db.collection(self.userPath).document(uid).getDocument { document, error in
                if let error = error {
                    promise(.failure(.firestore(error)))
                    return
                }
                
                guard let document = document else {
                    promise(.success(nil))
                    return
                }
                if document.exists {
                    let docRef = User(document: document)
                    promise(.success(docRef))
                } else {
                    promise(.success(nil))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func deleteUserListener(){
        FirestoreListener.shared.userListener?.remove()
    }
    
    func deletePairListener(){
        FirestoreListener.shared.pairListener?.remove()
    }
    
    func deleteChatListener(){
        FirestoreListener.shared.chatListener?.remove()
    }
    
    func checkAccountExists(email: String, isNewUser: Bool) -> AnyPublisher<Void, AppError>{
        return Future { promise in
            db.collection("User").whereField("email", isEqualTo: email)
                .getDocuments { querySnapshots, error in
                    if let error = error as? NSError {
                        promise(.failure(.firestore(error)))
                        return
                    }
                    if isNewUser {
                        if let documentsCount = querySnapshots?.count, documentsCount != 0 {
                            promise(.failure(.other(.alreadyHasAccountError)))
                            return
                        } else {
                            promise(.success(()))
                        }
                    } else {
                        guard let documentsCount = querySnapshots?.count, documentsCount != 0 else {
                            promise(.failure(.other(.hasNoAccountError)))
                            return
                        }
                        promise(.success(()))
                    }
                }
        }.eraseToAnyPublisher()
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
