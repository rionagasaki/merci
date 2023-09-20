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
    let chatPath = "Chat"
    let messagePath = "Message"
    let channelPath = "Channel"
    
    func createCall(channelId: String, channelTitle: String, user: UserObservableModel, completionHandler: @escaping(Result<Void, AppError>)->Void){
        db.collection(self.channelPath).document(channelId).setData([
            "channelId": channelId,
            "channelTitle": channelTitle,
            "hostUserId": user.user.uid,
            "hostUserImageUrlString": user.user.profileImageURLString,
            "userIdToUserIconImageUrlString": [user.user.uid: user.user.profileImageURLString],
            "userIdToUserName": [user.user.uid: user.user.nickname],
            "callingNow": true,
            "createdAt": Date.init()
        ]){ error in
            if let error {
                completionHandler(.failure(.firestore(error)))
            } else {
                completionHandler(.success(()))
            }
        }
    }
    
    func joinCall(channelId: String, user: UserObservableModel, completionHandler: @escaping(Result<Void, AppError>)->Void){
        db.collection(self.channelPath).document(channelId).setData([
            "userIdToUserIconImageUrlString": [user.user.uid: user.user.profileImageURLString],
            "userIdToUserName": [user.user.uid: user.user.nickname]
        ], merge: true){ error in
            if let error {
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
    
    func stopCall(channelId: String, completionHandler: @escaping(Result<Void, AppError>) -> Void){
        db.collection(self.channelPath).document(channelId).setData([
            "callingNow": false
        ], merge: true){ error in
            if let error {
                completionHandler(.failure(.firestore(error)))
            } else {
                completionHandler(.success(()))
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
        return Future { promise in
            db.collection(self.channelPath).document(channelId).updateData([
                "userIdToUserIconImageUrlString.\(userId)": FieldValue.delete(),
                "userIdToUserName.\(userId)": FieldValue.delete()
            ]){ error in
                if let error = error {
                    promise(.failure(.firestore(error)))
                } else {
                    promise(.success(()))
                }
            }
        }.eraseToAnyPublisher()
    }
}
