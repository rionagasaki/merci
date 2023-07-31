//
//  SetToFirestore.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/23.
//

import Foundation
import FirebaseFirestore
import FirebaseMessaging
import Combine

class SetToFirestore {
    
    static let shared = SetToFirestore()
    lazy var network = NetworkMonitor.shared.isConnected
    
    let userPath: String = "User"
    let pairPath: String = "Pair"
    let pastPairPath: String = "PastPair"
    let chatPath:String = "Chat"
    let messagePath: String = "Message"
    let reportPath: String = "Report"
    
    func registerInitialUserInfoToFirestore(userInfo: UserObservableModel) -> AnyPublisher<Void, AppError> {
        return Future { promise in
            db.collection(self.userPath).document(userInfo.user.uid).setData([
                "nickname": userInfo.user.nickname,
                "email": userInfo.user.email,
                "profileImageURL": userInfo.user.profileImageURL,
                "subProfileImageURLs": userInfo.user.subProfileImageURL,
                "gender": userInfo.user.gender,
                "activityRegion": userInfo.user.activeRegion,
                "introduction": userInfo.user.introduction,
                "hobbies": userInfo.user.hobbies,
                "birthDate": userInfo.user.birthDate,
                "onboarding": false
            ]){ error in
                if let error = error {
                    promise(.failure(.firestore(error)))
                } else {
                    promise(.success(()))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func doneOnboarding(user: UserObservableModel) -> AnyPublisher<Void, AppError>{
        return Future { promise in
            
            db.collection(self.userPath).document(user.user.uid).setData([
                "onboarding": true
            ], merge: true){ error in
                if let error = error as? NSError {
                    promise(.failure(.firestore(error)))
                } else {
                    promise(.success(()))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func userFcmTokenUpdate(uid: String, token: String) -> AnyPublisher<Void, AppError> {
        return Future { promise in
            db.collection(self.userPath).document(uid)
                .updateData(["fmcToken": token]){
                error in
                if let error = error {
                    promise(.failure(.firestore(error)))
                } else {
                    promise(.success(()))
                }
            }
        }
        .eraseToAnyPublisher()
    }
    
    //　ペア申請
    func requestPair(
        requestingUser: UserObservableModel,
        requestedUser: UserObservableModel
    ) -> AnyPublisher<Void, AppError> {
        return Future { promise in
                let batch = db.batch()
            let currentUserDoc = db.collection(self.userPath).document(requestingUser.user.uid)
                batch.updateData([
                    "pairRequestUid": requestedUser.user.uid
                ], forDocument: currentUserDoc)
                
            let pairUserDoc = db.collection(self.userPath).document(requestedUser.user.uid)
                batch.updateData([
                    "pairRequestedUids": FieldValue.arrayUnion([requestingUser.user.uid])
                ], forDocument: pairUserDoc)
                
                batch.commit { error in
                    if let error = error as? NSError {
                        promise(.failure(.firestore(error)))
                    } else {
                        promise(.success(()))
                    }
                }
        }.eraseToAnyPublisher()
    }
    
    func cancelPairRequest(
        requestingUser: UserObservableModel,
        requestedUser: UserObservableModel
    ) -> AnyPublisher<Void, AppError> {
        return Future { promise in
                let batch = db.batch()
            let currentUserDoc = db.collection(self.userPath).document(requestingUser.user.uid)
                batch.updateData([
                    "pairRequestUid": ""
                ], forDocument: currentUserDoc)
                
            let pairUserDoc = db.collection(self.userPath).document(requestedUser.user.uid)
                batch.updateData([
                    "pairRequestedUids": FieldValue.arrayRemove([requestingUser.user.uid])
                ], forDocument: pairUserDoc)
                
                batch.commit { error in
                    if let error = error as? NSError {
                        promise(.failure(.firestore(error)))
                    } else {
                        promise(.success(()))
                    }
                }
           
        }.eraseToAnyPublisher()
    }
    
    func updateMyIntroduction (
        currentUid: String,
        introduction: String
    ) -> AnyPublisher<Void, AppError> {
        return Future { promise in
            
            db.collection(self.userPath).document(currentUid).updateData([
                "introduction": introduction
            ]){ error in
                if let error = error {
                    promise(.failure(.firestore(error)))
                } else {
                    promise(.success(()))
                }
            }
            
        }.eraseToAnyPublisher()
    }
    
    func pairApprove(
        requestUser: UserObservableModel,
        requestedUser: UserObservableModel
    ) -> AnyPublisher<Void, AppError> {
        return Future { promise in
            let batch = db.batch()
            let pairID: String = UUID().uuidString
            let currentUserDoc = db.collection(self.userPath).document(requestUser.user.uid)
            let requestedUserDoc = db.collection(self.userPath).document(requestedUser.user.uid)
            let pairDoc = db.collection(self.pairPath).document(pairID)
            
            batch.setData([
                "isCurrentPair": true,
                "gender": requestUser.user.gender,
                "pair_1_uid": requestUser.user.uid,
                "pair_1_nickname": requestUser.user.nickname,
                "pair_1_profileImageURL": requestUser.user.profileImageURL,
                "pair_1_birthDate": requestUser.user.birthDate,
                "pair_1_activeRegion": requestUser.user.activeRegion,
                "pair_2_uid": requestedUser.user.uid,
                "pair_2_nickname": requestedUser.user.nickname,
                "pair_2_profileImageURL": requestedUser.user.profileImageURL,
                "pair_2_birthDate": requestedUser.user.birthDate,
                "pair_2_activeRegion": requestedUser.user.activeRegion
            ], forDocument: pairDoc)
            
            batch.setData([
                "pairID": pairID,
                "pairList": [requestUser.user.uid: pairID],
                "pairRequestedUids": FieldValue.arrayRemove([requestedUser.user.uid]),
                "pairUid": requestedUser.user.uid,
            ], forDocument: currentUserDoc, merge: true)
            
            batch.setData([
                "pairID": pairID,
                "pairList": [requestedUser.user.uid: pairID],
                "pairRequestUid": "",
                "pairUid": requestUser.user.uid
            ], forDocument: requestedUserDoc, merge: true)
            
            batch.commit { error in
                if let error = error as? NSError {
                    promise(.failure(.firestore(error)))
                } else {
                    promise(.success(()))
                }
            }
        }.eraseToAnyPublisher()
    }
 

    func changePairStatus(requestUser: UserObservableModel, requestedUser: UserObservableModel) -> AnyPublisher<Void, AppError> {
        let batch = db.batch()
        let requestUserDocRef = db.collection(userPath).document(requestUser.user.uid)
        let requestedUserDocRef = db.collection(userPath).document(requestedUser.user.uid)
        let pairDocRef = db.collection(pairPath).document(requestUser.user.pairID)
       
        return Future { promise in
            batch.setData([
                "pairID": "",
                "pairUid": ""
            ], forDocument: requestUserDocRef, merge: true)
            
            batch.setData([
                "pairID": "",
                "pairUid": ""
            ], forDocument: requestedUserDocRef, merge: true)
            
            batch.setData([
                "isCurrentPair": false
            ], forDocument: pairDocRef, merge: true)
            
            batch.commit { error in
                if let error = error as? NSError {
                    promise(.failure(.firestore(error)))
                } else {
                    promise(.success(()))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func addCoins(uid: String, increaseCoins: Int) -> AnyPublisher<Void, AppError>  {
        return Future { promise in
            db.collection(self.userPath).document(uid).updateData([
                "coins": FieldValue.increment(Int64(increaseCoins))
            ]){ error in
                if error != nil {
                    promise(.failure(.other(.addPointError)))
                } else {
                    promise(.success(()))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func updateHobbies(uid: String, hobbies: [String]) -> AnyPublisher<Void, AppError> {
        return Future { promise in
            db.collection(self.userPath).document(uid).updateData([
                "hobbies": hobbies
            ]){ error in
                if let error = error {
                    promise(.failure(.firestore(error)))
                } else {
                    promise(.success(()))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func updateDetailProfile(
        uid: String,
        fieldName:String,
        value: String
    ) -> AnyPublisher<Void, AppError>{
        return Future { promise in
            db.collection(self.userPath).document(uid).updateData([
                fieldName: value
            ]){ error in
                if let error = error {
                    promise(.failure(.firestore(error)))
                    return
                }
                promise(.success(()))
            }
        }.eraseToAnyPublisher()
    }
    
    func updateProfileImages(
        currentUser: UserObservableModel,
        pair: PairObservableModel
    ) -> AnyPublisher<Void, AppError>{
        let batch = db.batch()
        let userDocRef = db.collection(userPath).document(currentUser.user.uid)
        
        return Future { promise in
            if NetworkMonitor.shared.isConnected {
                batch.updateData([
                    "profileImageURL": currentUser.user.profileImageURL,
                    "subProfileImageURLs": currentUser.user.subProfileImageURL
                ], forDocument: userDocRef)
                
                if !currentUser.user.pairUid.isEmpty {
                    let pairDocRef = db.collection(self.pairPath).document(currentUser.user.pairID)
                    if pair.pair.pair_1_uid == currentUser.user.uid {
                        batch.updateData([
                            "pair_1_profileImageURL": currentUser.user.profileImageURL
                        ], forDocument: pairDocRef)
                    } else {
                        batch.updateData([
                            "pair_2_profileImageURL": currentUser.user.profileImageURL
                        ], forDocument: pairDocRef)
                    }
                }
                
                batch.commit { error in
                    if let error = error as? NSError {
                        promise(.failure(.firestore(error)))
                    } else {
                        promise(.success(()))
                    }
                }
            } else {
                promise(.failure(.other(.netWorkError)))
            }
        }.eraseToAnyPublisher()
    }
    
    // この関数は10コイン以上あるユーザーしか呼べない。
    func makeChat (
        requestPairID: String,
        requestedPairID: String,
        message: String,
        sendUserInfo: UserObservableModel,
        currentPairUserID:String,
        currentChatPairUserID_1:String,
        currentChatPairUserID_2:String,
        recieveNotificatonTokens:[String],
        createdAt: Date
    ) -> AnyPublisher<String, AppError> {
        let timestamp = Timestamp(date: createdAt)
        let chatDocumentID = UUID().uuidString
        
        let batch = db.batch()
        
        let chatDoc = db.collection(chatPath).document(chatDocumentID)
        let messageDoc = db.collection(chatPath).document(chatDocumentID).collection(messagePath).document(UUID().uuidString)
        
        let requestedPairDoc = db.collection(pairPath).document(requestedPairID)
        let requestPairDoc = db.collection(pairPath).document(requestPairID)
        
        let currentUserDoc = db.collection(userPath).document(sendUserInfo.user.uid)
        let currentPairUserDoc = db.collection(userPath).document(currentPairUserID)
        let currentChatPairUserID_1_Doc = db.collection(userPath).document(currentChatPairUserID_1)
        let currentChatPairUserID_2_Doc = db.collection(userPath).document(currentChatPairUserID_2)
        
        return Future { promise in
            if message.isEmpty {
                promise(.failure(.other(.noMessageSendError)))
                return
            }
            batch.setData([
                "pairs": FieldValue.arrayUnion([requestedPairID, requestPairID])
            ], forDocument: chatDoc)
            
            batch.setData([
                "sendUserID": sendUserInfo.user.uid,
                "sendUserNickname": sendUserInfo.user.nickname,
                "sendUserProfileImageURL": sendUserInfo.user.profileImageURL,
                "message": message,
                "createdAt": timestamp,
                "notificationUserTokens": recieveNotificatonTokens
            ], forDocument: messageDoc)
            
            batch.setData([
                "chatPairIDs": [requestPairID: chatDocumentID as Any],
                "chatPairLastMessage": [requestPairID: message],
                "chatPairLastCreatedAt": [requestPairID: timestamp]
            ],forDocument: requestedPairDoc, merge: true)
            
            batch.setData([
                "chatPairIDs": [requestedPairID: chatDocumentID as Any],
                "chatPairLastMessage": [requestedPairID: message],
                "chatPairLastCreatedAt": [requestedPairID: timestamp]
            ],forDocument: requestPairDoc, merge: true)
            
            batch.setData([
                "chatUnreadNum": [chatDocumentID: FieldValue.increment(Int64())]
            ],forDocument: currentPairUserDoc ,merge: true)
            
            batch.setData([
                "chatUnreadNum": [chatDocumentID: FieldValue.increment(Int64())]
            ],forDocument: currentChatPairUserID_1_Doc, merge: true)
            
            batch.setData([
                "chatUnreadNum": [chatDocumentID: FieldValue.increment(Int64())]
            ],forDocument: currentChatPairUserID_2_Doc, merge: true)
            
            batch.setData([
                "chatUnreadNum": [chatDocumentID: 0],
                "coins": FieldValue.increment(Int64(-10))
            ], forDocument: currentUserDoc, merge: true)
            
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
        chatRoomID: String,
        currentUserPairID: String,
        chatPairID: String,
        currentPairUserID:String,
        currentChatPairUserID_1:String,
        currentChatPairUserID_2:String,
        createdAt:Date ,
        message: String,
        user: UserObservableModel,
        recieveNotificatonTokens:[String]
    ) -> AnyPublisher<Void, AppError> {
        let timestamp = Timestamp(date: createdAt)
        // 途中で処理が失敗すると整合性が取れなくなるためここではバッチ処理。
        let batch = db.batch()
        
        let messageDoc = db.collection(chatPath).document(chatRoomID).collection(messagePath).document(UUID().uuidString)
        
        let currentUserPairDoc = db.collection(pairPath).document(currentUserPairID)
        let chatPairDoc = db.collection(pairPath).document(chatPairID)
        
        let currentUserDoc = db.collection(userPath).document(user.user.uid)
        let currentPairUserDoc = db.collection(userPath).document(currentPairUserID)
        let currentChatPairUserID_1_Doc = db.collection(userPath).document(currentChatPairUserID_1)
        let currentChatPairUserID_2_Doc = db.collection(userPath).document(currentChatPairUserID_2)
        
        return Future { promise in
            
            if message.isEmpty {
                promise(.failure(.other(.noMessageSendError)))
                return
            }
            
            batch.setData([
                "sendUserID": user.user.uid,
                "sendUserNickname": user.user.nickname,
                "sendUserProfileImageURL": user.user.profileImageURL,
                "message": message,
                "createdAt": timestamp,
                "notificationUserTokens": recieveNotificatonTokens
            ], forDocument: messageDoc, merge: true)
            
            batch.setData([
                "chatPairLastMessage": [chatPairID: message],
                "chatPairLastCreatedAt": [chatPairID: timestamp]
            ], forDocument: currentUserPairDoc, merge: true)
            
            batch.setData([
                "chatPairLastMessage": [currentUserPairID: message],
                "chatPairLastCreatedAt": [currentUserPairID: timestamp]
            ],forDocument: chatPairDoc, merge: true)
            
            batch.setData([
                "chatUnreadNum": [chatRoomID: 0]
            ],forDocument: currentUserDoc, merge: true)
            
            batch.setData([
                "chatUnreadNum": [chatRoomID: FieldValue.increment(Int64(1))]
            ],forDocument: currentPairUserDoc, merge: true)
            
            batch.setData([
                "chatUnreadNum": [chatRoomID: FieldValue.increment(Int64())]
            ],forDocument: currentChatPairUserID_1_Doc ,merge: true)
            
            batch.setData([
                "chatUnreadNum": [chatRoomID: FieldValue.increment(Int64())]
            ],forDocument: currentChatPairUserID_2_Doc ,merge: true)
            
            batch.commit { error in
                if let error = error {
                    promise(.failure(.firestore(error)))
                } else {
                    promise(.success(()))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func report(reportUserID: String, reportedUserID: [String], reportText: String) -> AnyPublisher<Void, AppError>{
        let db = Firestore.firestore()
        return Future { promise in
            db.collection(self.reportPath).document(UUID().uuidString).setData([
                "reportUserID": reportUserID,
                "reportedUserID": reportedUserID,
                "reportText": reportText
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
