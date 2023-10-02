//
//  CallFirestoreService.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/08/21.
//

import Foundation
import Combine
import FirebaseFirestore

class CallFirestoreService {
    private let userPath = "User"
    private let chatPath = "Chat"
    private let messagePath = "Message"
    private let channelPath = "Channel"
    
    func createCall(channelId: String, channelTitle: String, user: UserObservableModel, completionHandler: @escaping(Result<Void, AppError>)->Void){
        
        let batch = db.batch()
        let userDocRef = db.collection(self.userPath).document(user.user.uid)
        let channelDocRef = db.collection(self.channelPath).document(channelId)
        
        batch.updateData([
            "isCallingChannelId": channelId
        ], forDocument: userDocRef)
        
        batch.setData([
            "channelId": channelId,
            "channelTitle": channelTitle,
            "hostUserId": user.user.uid,
            "hostUserImageUrlString": user.user.profileImageURLString,
            "userIdToUserIconImageUrlString": [user.user.uid: user.user.profileImageURLString],
            "userIdToUserName": [user.user.uid: user.user.nickname],
            "callingNow": true,
            "createdAt": Date.init()
        ], forDocument: channelDocRef, merge: false)
        
        batch.commit { error in
            if let error = error {
                completionHandler(.failure(.firestore(error)))
            } else {
                completionHandler(.success(()))
            }
        }
    }
    
    func joinCall(channelId: String, user: UserObservableModel, completionHandler: @escaping(Result<Void, AppError>)->Void){
        
        let batch = db.batch()
        let userDocRef = db.collection(self.userPath).document(user.user.uid)
        let channelDocRef = db.collection(self.channelPath).document(channelId)
        
        batch.updateData([
            "isCallingChannelId": channelId
        ], forDocument: userDocRef)
        
        batch.setData([
            "userIdToUserIconImageUrlString": [user.user.uid: user.user.profileImageURLString],
            "userIdToUserName": [user.user.uid: user.user.nickname]
        ],forDocument: channelDocRef ,merge: true)
        
        batch.commit { error in
            if let error = error {
                completionHandler(.failure(.firestore(error)))
            } else {
                completionHandler(.success(()))
            }
        }
    }
    
    func getCall() -> AnyPublisher<[CallObservableModel], AppError>{
        return Future { promise in
            db.collection(self.channelPath).whereField("callingNow", isEqualTo: true).getDocuments { querySnapshots, error in
                if let _ = error {
                    promise(.failure(.other(.unexpectedError)))
                    return
                }
                var calls: [CallObservableModel] = []
                guard let querySnapshots = querySnapshots else { return }
                calls = querySnapshots.documents.map { .init(callModel: Call(document: $0).adaptCall()) }
                promise(.success(calls))
            }
        }.eraseToAnyPublisher()
    }
    
    func stopCall(userID: String, channelId: String, completionHandler: @escaping(Result<Void, AppError>) -> Void){
        let userDocRef = db.collection(self.userPath).document(userID)
        
        userDocRef.updateData([
            "isCallingChannelId": ""
        ]) { error in
            if let error = error {
                completionHandler(.failure(.firestore(error)))
            } else {
                completionHandler(.success(()))
            }
        }
    }
    
    func stopCallConcurrentlly(userIDs:[String], channelID: String, completionHandler: @escaping(Result<Void, AppError>)->Void) {
        let dispatchGroup =  DispatchGroup()
        let batch = db.batch()
        let channelDocRef = db.collection(self.channelPath).document(channelID)
        
        batch.updateData([
            "callingNow": false
        ], forDocument: channelDocRef)
        for userID in userIDs {
            dispatchGroup.enter()
            self.stopCall(userID: userID, channelId: channelID) { _ in do { dispatchGroup.leave() } }
        }
        
        dispatchGroup.notify(queue: .main) {
            batch.commit { error in
                if let error = error {
                    completionHandler(.failure(.firestore(error)))
                } else {
                    completionHandler(.success(()))
                }
            }
        }
    }
    
    func getUpdateCallById(channelId: String) -> AnyPublisher<CallObservableModel, AppError> {
        let subject = PassthroughSubject<CallObservableModel, AppError>()
        FirestoreListener.shared.callListener?.remove()
        FirestoreListener.shared.callListener = db.collection(self.channelPath).document(channelId).addSnapshotListener { documentSnapshot, error in
            if let error = error {
                subject.send(completion: .failure(.firestore(error)))
            } else if let document = documentSnapshot, document.exists {
                let callData = Call(document: document)
                subject.send(.init(callModel: callData.adaptCall()))
            }
        }
        return subject.eraseToAnyPublisher()
    }
    
    func leaveChannel(channelId: String, userId: String) -> AnyPublisher<Void, AppError> {
        let batch = db.batch()
        let userDocRef = db.collection(self.userPath).document(userId)
        let channelDocRef = db.collection(self.channelPath).document(channelId)
        
        return Future { promise in
            batch.updateData([
                "isCallingChannelId": channelId
            ], forDocument: userDocRef)
            
            batch.updateData([
                "userIdToUserIconImageUrlString.\(userId)": FieldValue.delete(),
                "userIdToUserName.\(userId)": FieldValue.delete()
            ], forDocument: channelDocRef)
            
            batch.commit { error in
                if let error = error {
                    promise(.failure(.firestore(error)))
                } else {
                    promise(.success(()))
                }
            }
        }.eraseToAnyPublisher()
    }
}
