//
//  ChatFirestoreService.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/08/21.
//

import Foundation
import Combine
import FirebaseFirestore

class ChatFirestoreService {
    let userPath: String = "User"
    let chatPath:String = "Chat"
    let messagePath: String = "Message"
    let callPath: String = "Call"
    
    private var lastDocument: DocumentSnapshot?
    
    private let orderLimit = 20
    
    func getUpdateChatRoomData(chatroomID: String) -> AnyPublisher<ChatRoomData, AppError> {
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
    
    private func createQuery(chatroomID: String, lastDoc: DocumentSnapshot?) -> Query {
        var query: Query =  db
            .collection(self.chatPath)
            .document(chatroomID)
            .collection(self.messagePath)
            .order(by: "createdAt", descending: true)
        
        if let lastDoc = lastDoc {
            query = query.start(afterDocument: lastDoc)
        }
        
        return query
    }
    
    func getMessageData(chatroomID: String, lastDoc: DocumentSnapshot? = nil) async throws -> [Chat] {
        let querySnapshot = try await createQuery(chatroomID: chatroomID, lastDoc: lastDoc).getDocuments()
        let chats = querySnapshot.documents.map {
            return Chat(document: $0)
        }
        return chats
    }
    
    func getNextMessageData(chatroomID: String) async throws -> [Chat] {
        let chats = try await self.getMessageData(chatroomID: chatroomID, lastDoc: self.lastDocument)
        return chats
    }
    
    func getUpdateLatestMessageData(chatRoomID:String) -> AnyPublisher<Chat, AppError> {
        let subject = PassthroughSubject<Chat, AppError>()
        FirestoreListener.shared.chatListener?.remove()
        FirestoreListener.shared.chatListener = db
            .collection(self.chatPath)
            .document(chatRoomID)
            .collection(self.messagePath)
            .order(by: "createdAt", descending: true)
            .limit(to: 1)
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
                    switch diff.type {
                    case .added:
                        let docRef = Chat(document: diff.document)
                        subject.send(docRef)
                    case .modified:
                        break
                    case .removed:
                        break
                    }
                }
            }
        return subject.eraseToAnyPublisher()
    }
    
    func createConcernChatRoonAndSendMessage(
        message: String,
        concernID: String,
        concernKind: String,
        concernText: String,
        concernKindImageName: String,
        fromUser: UserObservableModel,
        toUser: UserObservableModel,
        createdAt: Date
    ) async throws -> Void {
        let timestamp = Timestamp(date: createdAt)
        let chatDocumentID = UUID().uuidString
        let messageDocumentID = UUID().uuidString
        
        let batch = db.batch()
        
        let chatDoc = db.collection(self.chatPath).document(chatDocumentID)
        let messageDoc = db.collection(self.chatPath).document(chatDocumentID).collection(self.messagePath).document(messageDocumentID)
        
        let fromUserDoc = db.collection(self.userPath).document(fromUser.user.uid)
        let toUserDoc = db.collection(self.userPath).document(toUser.user.uid)
        
        if message.isEmpty {
            throw AppError.other(.noMessageSendError)
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
            "type": "Concern",
            "fromUserUid": fromUser.user.uid,
            "fromUserNickname": fromUser.user.nickname,
            "fromUserProfileImageUrl": fromUser.user.profileImageURLString,
            "toUserToken": toUser.user.fcmToken,
            "message": message,
            "createdAt": timestamp,
            "concernID": concernID,
            "concernKind": concernKind,
            "concernText": concernText,
            "concernKindImageName": concernKindImageName
        ], forDocument: messageDoc)
        
        try await batch.commit()
    }
    
    func createChatRoomAndSendMessage (
        message: String,
        fromUser: UserObservableModel,
        toUser: UserObservableModel,
        createdAt: Date
    ) async throws -> String {
        let timestamp = Timestamp(date: createdAt)
        let chatDocumentID = UUID().uuidString
        let messageDocumentID = UUID().uuidString
        
        let batch = db.batch()
        
        let chatDoc = db.collection(self.chatPath).document(chatDocumentID)
        let messageDoc = db.collection(self.chatPath).document(chatDocumentID).collection(self.messagePath).document(messageDocumentID)
        
        let fromUserDoc = db.collection(self.userPath).document(fromUser.user.uid)
        let toUserDoc = db.collection(self.userPath).document(toUser.user.uid)
        
        if message.isEmpty {
            throw AppError.other(.noMessageSendError)
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
        
        try await batch.commit()
        
        return chatDocumentID
    }
    
    func sendMessage (
        chatRoomId: String,
        fromUser: UserObservableModel,
        toUser: UserObservableModel,
        createdAt:Date,
        message: String
    ) async throws -> Void {
        let timestamp = Timestamp(date: createdAt)
        let batch = db.batch()
        let messageDoc = db.collection(self.chatPath).document(chatRoomId).collection(messagePath).document(UUID().uuidString)
        let fromUserDoc = db.collection(self.userPath).document(fromUser.user.uid)
        let toUserDoc = db.collection(self.userPath).document(toUser.user.uid)
        
        if message.isEmpty {
            throw AppError.other(.noMessageSendError)
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
        
        if toUser.user.hiddenChatRoomUserIDs.contains(fromUser.user.uid) {
            batch.setData([
                "chatLastMessageMapping": [chatRoomId: message],
                "chatLastTimestampMapping": [chatRoomId: timestamp],
                "unreadMessageCount": [chatRoomId: FieldValue.increment(Int64(1))],
                "hiddenChatRoomUserIDs": FieldValue.arrayRemove([fromUser.user.uid])
            ],forDocument: toUserDoc, merge: true)
        } else {
            batch.setData([
                "chatLastMessageMapping": [chatRoomId: message],
                "chatLastTimestampMapping": [chatRoomId: timestamp],
                "unreadMessageCount": [chatRoomId: FieldValue.increment(Int64(1))]
            ],forDocument: toUserDoc, merge: true)
        }
        
        try await batch.commit()
    }
    
    func sendConcernMessage (
        chatRoomId: String,
        fromUser: UserObservableModel,
        toUser: UserObservableModel,
        createdAt:Date,
        message: String,
        concernID: String,
        concernKind: String,
        concernText: String,
        concernKindImageName: String
    ) async throws -> Void {
        let timestamp = Timestamp(date: createdAt)
        let batch = db.batch()
        let messageDoc = db.collection(self.chatPath).document(chatRoomId).collection(messagePath).document(UUID().uuidString)
        let fromUserDoc = db.collection(self.userPath).document(fromUser.user.uid)
        let toUserDoc = db.collection(self.userPath).document(toUser.user.uid)
        
        if message.isEmpty {
            throw AppError.other(.noMessageSendError)
        }
        
        batch.setData([
            "type": "Concern",
            "fromUserUid": fromUser.user.uid,
            "fromUserNickname": fromUser.user.nickname,
            "fromUserProfileImageUrl": fromUser.user.profileImageURLString,
            "toUserToken": toUser.user.fcmToken,
            "message": message,
            "createdAt": timestamp,
            "concernID": concernID,
            "concernKind": concernKind,
            "concernText": concernText,
            "concernKindImageName": concernKindImageName
        ], forDocument: messageDoc, merge: true)
        
        batch.setData([
            "chatLastMessageMapping": [chatRoomId: message],
            "chatLastTimestampMapping": [chatRoomId: timestamp]
        ], forDocument: fromUserDoc, merge: true)
        
        if toUser.user.hiddenChatRoomUserIDs.contains(fromUser.user.uid) {
            batch.setData([
                "chatLastMessageMapping": [chatRoomId: message],
                "chatLastTimestampMapping": [chatRoomId: timestamp],
                "unreadMessageCount": [chatRoomId: FieldValue.increment(Int64(1))],
                "hiddenChatRoomUserIDs": FieldValue.arrayRemove([fromUser.user.uid])
            ],forDocument: toUserDoc, merge: true)
        } else {
            batch.setData([
                "chatLastMessageMapping": [chatRoomId: message],
                "chatLastTimestampMapping": [chatRoomId: timestamp],
                "unreadMessageCount": [chatRoomId: FieldValue.increment(Int64(1))]
            ],forDocument: toUserDoc, merge: true)
        }
        
        try await batch.commit()
    }
    
    func updateMessageCountZero(readUser: UserObservableModel, chatRoomId: String) async throws {
        let fromUserDoc = db.collection(self.userPath).document(readUser.user.uid)
        try await fromUserDoc.updateData([
            "unreadMessageCount": [chatRoomId: 0]
        ])
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
                "chatLastMessageMapping": [chatRoomId: "\(fromUser.user.nickname)さんが通話を始めました"],
                "chatLastTimestampMapping": [chatRoomId: Date.init()],
                "unreadMessageCount": [chatRoomId: FieldValue.increment(Int64(1))],
                "isCallingChannelId": channelId
            ],forDocument: fromUserDoc, merge: true)
            
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
            
            batch.commit { error in
                if let error = error {
                    promise(.failure(.firestore(error)))
                } else {
                    promise(.success(()))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func joinOneToOneCall(chatRoomId: String, channelId: String ,user: UserObservableModel, completionHandler: @escaping (Result<Void, AppError>) -> Void) {
        let batch = db.batch()
        let chatDocRef = db.collection(self.chatPath).document(chatRoomId)
        let userDocRef = db.collection(self.userPath).document(user.user.uid)
        
        batch.updateData([
            "isCallingChannelId": channelId
        ], forDocument: userDocRef)
        
        batch.updateData([
            "callingMate": FieldValue.arrayUnion([user.user.uid])
        ], forDocument: chatDocRef)
        
        batch.commit { error in
            if let error = error {
                completionHandler(.failure(.firestore(error)))
            } else {
                completionHandler(.success(()))
            }
        }
    }
    
    func stopOneToOneCall(chatRoomId: String, fromUserID: String, toUserID: String, completionHandler: @escaping(Result<Void, AppError>)->Void) {
        let batch = db.batch()
        let chatDocRef = db.collection(self.chatPath).document(chatRoomId)
        let fromUserDocRef = db.collection(self.userPath).document(fromUserID)
        let toUserDocRef = db.collection(self.userPath).document(toUserID)
        
        batch .updateData([
            "channelId": "",
            "callingMate": [] as [String]
        ], forDocument: chatDocRef)
        
        batch.updateData([
            "isCallingChannelId": ""
        ], forDocument: fromUserDocRef)
        
        batch.updateData([
            "isCallingChannelId": ""
        ], forDocument: toUserDocRef)
        
        batch.commit { error in
            if let error = error {
                completionHandler(.failure(.firestore(error)))
            } else {
                completionHandler(.success(()))
            }
        }
    }
}
