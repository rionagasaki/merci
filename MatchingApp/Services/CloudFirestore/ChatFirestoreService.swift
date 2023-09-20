//
//  ChatFirestoreService.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/08/21.
//

import Foundation
import Combine
import FirebaseFirestore

enum MessageType: String {
    case message = "Message"
    case call = "Call"
}

class ChatFirestoreService {
    let userPath: String = "User"
    let chatPath:String = "Chat"
    let messagePath: String = "Message"
    let callPath: String = "Call"
    
    func getChatRoomData(chatroomID: String) -> AnyPublisher<ChatRoomData, AppError> {
        let subject = PassthroughSubject<ChatRoomData, AppError>()
        FirestoreListener.shared.chatListener?.remove()
        FirestoreListener.shared.chatRoomListener = db
            .collection(self.chatPath)
            .document(chatroomID)
            .addSnapshotListener { document, error in
                if let error = error {
                    subject.send(completion: .failure(.firestore(error)))
                } else {
                    guard let document = document else {
                        subject.send(completion: .failure(.other(.unexpectedError)))
                        return
                    }
                    let chatRoomDocRef = ChatRoomData(document: document)
                    subject.send(chatRoomDocRef)
                }
            }
        return subject.eraseToAnyPublisher()
    }
    
    func getUpdateChat(chatroomID:String) -> AnyPublisher<Chat, AppError> {
        let subject = PassthroughSubject<Chat, AppError>()
        FirestoreListener.shared.chatListener?.remove()
        FirestoreListener.shared.chatListener = db
            .collection(self.chatPath)
            .document(chatroomID)
            .collection(self.messagePath)
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
    
    func createChatRoomAndSendMessage (
        message: String,
        fromUser: UserObservableModel,
        toUser: UserObservableModel,
        createdAt: Date
    ) -> AnyPublisher<String, AppError> {
        let timestamp = Timestamp(date: createdAt)
        let chatDocumentID = UUID().uuidString
        let messageDocumentID = UUID().uuidString
        
        let batch = db.batch()
        
        let chatDoc = db.collection(self.chatPath).document(chatDocumentID)
        let messageDoc = db.collection(self.chatPath).document(chatDocumentID).collection(self.messagePath).document(messageDocumentID)
        
        let fromUserDoc = db.collection(self.userPath).document(fromUser.user.uid)
        let toUserDoc = db.collection(self.userPath).document(toUser.user.uid)
        
        return Future { promise in
            if message.isEmpty {
                promise(.failure(.other(.noMessageSendError)))
                return
            }
            
            batch.setData([
                "chatmateMapping": [toUser.user.uid: chatDocumentID]
            ], forDocument: fromUserDoc, merge: true)
            
            batch.setData([
                "chatmateMapping": [fromUser.user.uid: chatDocumentID]
            ], forDocument: toUserDoc, merge: true)
            
            batch.setData([
                "chatLastMessageMapping": [chatDocumentID: message],
                "chatLastTimestampMapping": [chatDocumentID: timestamp]
            ], forDocument: fromUserDoc, merge: true)
            
            batch.setData([
                "chatLastMessageMapping": [chatDocumentID: message],
                "chatLastTimestampMapping": [chatDocumentID: timestamp],
                "unreadMessageCount": [chatDocumentID: FieldValue.increment(Int64(1))]
            ],forDocument: toUserDoc, merge: true)
            
            batch.setData([
                "chatmate": FieldValue.arrayUnion([fromUser.user.uid, toUser.user.uid])
            ], forDocument: chatDoc)
            
            batch.setData([
                "type": "Message",
                "fromUserUid": fromUser.user.uid,
                "fromUserNickname": fromUser.user.nickname,
                "fromUserProfileImageUrl": fromUser.user.profileImageURLString,
                "toUserToken": toUser.user.fcmToken,
                "message": message,
                "createdAt": timestamp,
            ], forDocument: messageDoc)
            
            batch.commit { error in
                if let error = error {
                    promise(.failure(.firestore(error)))
                } else {
                    promise(.success(chatDocumentID))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func sendMessage (
        chatRoomId: String,
        fromUser: UserObservableModel,
        toUser: UserObservableModel,
        createdAt:Date,
        message: String
    ) -> AnyPublisher<Void, AppError> {
        let timestamp = Timestamp(date: createdAt)
        let batch = db.batch()
        let messageDoc = db.collection(self.chatPath).document(chatRoomId).collection(messagePath).document(UUID().uuidString)
        let fromUserDoc = db.collection(self.userPath).document(fromUser.user.uid)
        let toUserDoc = db.collection(self.userPath).document(toUser.user.uid)
        
        return Future { promise in
            if message.isEmpty {
                promise(.failure(.other(.noMessageSendError)))
                return
            }
            
            batch.setData([
                "type": "Message",
                "fromUserUid": fromUser.user.uid,
                "fromUserNickname": fromUser.user.nickname,
                "fromUserProfileImageUrl": fromUser.user.profileImageURLString,
                "toUserToken": toUser.user.fcmToken,
                "message": message,
                "createdAt": timestamp
            ], forDocument: messageDoc, merge: true)
            
            batch.setData([
                "chatLastMessageMapping": [chatRoomId: message],
                "chatLastTimestampMapping": [chatRoomId: timestamp]
            ], forDocument: fromUserDoc, merge: true)
            
            batch.setData([
                "chatLastMessageMapping": [chatRoomId: message],
                "chatLastTimestampMapping": [chatRoomId: timestamp],
                "unreadMessageCount": [chatRoomId: FieldValue.increment(Int64(1))]
            ],forDocument: toUserDoc, merge: true)
            
            batch.commit { error in
                if let error = error {
                    promise(.failure(.firestore(error)))
                } else {
                    promise(.success(()))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func updateMessageCountZero(readUser: UserObservableModel, chatRoomId: String) -> AnyPublisher<Void, AppError> {
        let fromUserDoc = db.collection(self.userPath).document(readUser.user.uid)
        return Future { promise in
            fromUserDoc.updateData([
                "unreadMessageCount": [chatRoomId: 0]
            ]){ error in
                if let error = error {
                    promise(.failure(.firestore(error)))
                } else {
                    promise(.success(()))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func createOneToOneCall(
        chatRoomId: String,
        channelId: String,
        fromUser: UserObservableModel,
        toUser: UserObservableModel
    ) -> AnyPublisher<Void, AppError> {
        let batch = db.batch()
        let messageDocId = UUID().uuidString
        let fromUserDoc = db.collection(self.userPath).document(fromUser.user.uid)
        let toUserDoc = db.collection(self.userPath).document(toUser.user.uid)
        let callDoc = db.collection(self.chatPath).document(chatRoomId)
        let messageDoc = db.collection(self.chatPath).document(chatRoomId).collection(self.messagePath).document(messageDocId)
        
        return Future { promise in
            batch.setData([
                "channelId": channelId,
                "callingMate": FieldValue.arrayUnion([fromUser.user.uid])
            ], forDocument: callDoc, merge: true)
            
            batch.setData([
                "type": "Call",
                "fromUserUid": fromUser.user.uid,
                "fromUserNickname": fromUser.user.nickname,
                "fromUserProfileImageUrl": fromUser.user.profileImageURLString,
                "toUserToken": toUser.user.fcmToken,
                "message": "\(fromUser.user.nickname)さんが通話を始めました。",
                "createdAt": Date.init()
            ], forDocument: messageDoc)
            
            batch.setData([
                "chatLastMessageMapping": [chatRoomId: "\(fromUser.user.nickname)さんが通話を始めました"],
                "chatLastTimestampMapping": [chatRoomId: Date.init()],
                "unreadMessageCount": [chatRoomId: FieldValue.increment(Int64(1))]
            ],forDocument: toUserDoc, merge: true)
            
            batch.setData([
                "chatLastMessageMapping": [chatRoomId: "\(fromUser.user.nickname)さんが通話を始めました"],
                "chatLastTimestampMapping": [chatRoomId: Date.init()],
                "unreadMessageCount": [chatRoomId: FieldValue.increment(Int64(1))]
            ],forDocument: fromUserDoc, merge: true)
            
            batch.commit { error in
                if let error = error {
                    promise(.failure(.firestore(error)))
                } else {
                    promise(.success(()))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func joinOneToOneCall(chatRoomId: String, user: UserObservableModel, completionHandler: @escaping (Result<Void, AppError>) -> Void) {
        db.collection(self.chatPath).document(chatRoomId).setData([
            "callingMate": FieldValue.arrayUnion([chatRoomId])
        ], merge: true){ error in
            if let error = error {
                completionHandler(.failure(.firestore(error)))
            } else {
                completionHandler(.success(()))
            }
        }
    }
    
    func stopOneToOneCall(chatRoomId: String, completionHandler: @escaping(Result<Void, AppError>)->Void) {
        db.collection(self.chatPath)
            .document(chatRoomId)
            .updateData([
                "channelId": "",
                "callingMate": [] as [String],
            ]){ error in
                if let error = error {
                    completionHandler(.failure(.firestore(error)))
                } else {
                    completionHandler(.success(()))
                }
            }
    }
    
    
}
