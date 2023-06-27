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
    let userPath: String = "User"
    let pairPath: String = "Pair"
    let pastPairPath: String = "PastPair"
    let chatPath:String = "Chat"
    let messagePath: String = "Message"
    
    func registerUserInfoFirestore(
        uid: String,
        nickname: String,
        email: String,
        profileImageURL: String,
        subProfileImageURLs: [String],
        gender:String,
        activityRegion: String,
        birthDate: String,
        introduction: String,
        hobbies: [String],
        completion: @escaping ()-> Void
    ){
        db.collection(userPath).document(uid).setData([
            "nickname": nickname,
            "email": email,
            "profileImageURL": profileImageURL,
            "subProfileImageURLs": subProfileImageURLs,
            "gender": gender,
            "activityRegion": activityRegion,
            "introduction": introduction,
            "hobbies": hobbies,
            "birthDate": birthDate,
        ]){ err in
            if let err = err {
                print("Error=>registerUserInfoFirestore:\(String(describing: err))")
            } else {
                completion()
            }
        }
    }
    
    func deleteAccount() {
        let batch = db.batch()
    }
    
    func deleteChat(
        currentUser: UserObservableModel
        
    ){
        let batch = db.batch()
        let currentUserDoc = db.collection(userPath).document()
        
    }
    
    func updateFcmToken(
        user: UserObservableModel,
        pair: PairObservableModel,
        newestToken: String
    ){
        let batch = db.batch()
        let currentUserDic = db.collection(userPath).document(user.uid)
        
        // fcmTokenが更新されているならUpdateしておく。
        if user.fcmToken != newestToken {
            batch.updateData([
                "fcmToken": newestToken
            ], forDocument: currentUserDic)
            
            if user.pairID != "" {
                let currentPairDic = db.collection(pairPath).document(user.pairID)
                if pair.pair.pair_1_uid == user.uid {
                    batch.updateData([
                        "pair_1_fcmToken": newestToken
                    ], forDocument: currentPairDic)
                } else {
                    batch.updateData([
                        "pair_2_fcmToken": newestToken
                    ], forDocument: currentPairDic)
                }
            }
            
            batch.commit { error in
                if let error = error {
                    print(error)
                    // エラーアラートを出す。
                } else {
                    print("Friend successfully updated!")
                }
            }
        }
    }
    
    // フレンド申請
    func requestFriend(
        currentUid: String,
        pairUserUid: String
    ){
        let batch = db.batch()
        
        let currentUserDoc = db.collection(userPath).document(currentUid)
        batch.updateData([
            "requestUid": FieldValue.arrayUnion([pairUserUid])
        ], forDocument: currentUserDoc)
        
        let pairUserDoc = db.collection(userPath).document(pairUserUid)
        batch.updateData([
            "requestedUid": FieldValue.arrayUnion([currentUid])
        ], forDocument: pairUserDoc)
        
        batch.commit { error in
            if let error = error {
                print(error)
                // エラーアラートを出す。
            } else {
                print("Friend successfully updated!")
            }
        }
    }
    
    //　ペア申請
    func requestPair(
        currentUid: String,
        pairUserUid: String
    ){
        let batch = db.batch()
        
        let currentUserDoc = db.collection(userPath).document(currentUid)
        batch.updateData([
            "pairRequestUid": pairUserUid
        ], forDocument: currentUserDoc)
        
        let pairUserDoc = db.collection(userPath).document(pairUserUid)
        batch.updateData([
            "pairRequestedUids": FieldValue.arrayUnion([currentUid])
        ], forDocument: pairUserDoc)
        
        batch.commit { error in
            if let error = error {
                print(error)
                // エラーアラートを出す。
            } else {
                print("Friend successfully updated!")
            }
        }
    }
    
    func cancelPairRequest(
        currentUid: String,
        pairUserUid: String
    ){
        let batch = db.batch()
        
        let currentUserDoc = db.collection(userPath).document(currentUid)
        batch.updateData([
            "pairRequestUid": ""
        ], forDocument: currentUserDoc)
        
        let pairUserDoc = db.collection(userPath).document(pairUserUid)
        batch.updateData([
            "pairRequestedUids": FieldValue.arrayRemove([currentUid])
        ], forDocument: pairUserDoc)
        
        batch.commit { error in
            if let error = error {
                print(error)
                // エラーアラートを出す。
            } else {
                print("Friend successfully updated!")
            }
        }
    }
    
    func updateMyIntroduction(
        currentUid: String,
        introduction: String
    ){
        db.collection(userPath).document(currentUid).updateData([
            "introduction": introduction
        ])
    }
    
    func updateFriend(
        currentUser:UserObservableModel,
        requestedUid: String
    ){
        let batch = db.batch()
        // リクエストされて承認した側
        let currentUserDoc = db.collection(userPath).document(currentUser.uid)
        batch.updateData([
            "requestedUid": FieldValue.arrayRemove([requestedUid]),
            "friendUids": FieldValue.arrayUnion([requestedUid])
        ], forDocument: currentUserDoc)
        
        // リクエストした側のDBをいじる(現在ログインしているユーザから見れば、requestedUidを持つユーザ)
        let requestedUserDoc = db.collection(userPath).document(requestedUid)
        batch.updateData([
            "requestUid": FieldValue.arrayRemove([currentUser.uid]),
            "friendUids": FieldValue.arrayUnion([currentUser.uid])
        ], forDocument: requestedUserDoc)
        
        batch.commit { error in
            if let error = error {
                print(error)
                // エラーアラートを出す。
            } else {
                print("Friend successfully updated!")
            }
        }
    }
    
    
    func updatePair(
        currentUser: UserObservableModel,
        requestedUser: UserObservableModel
    ){
        
        db.collection(userPath).document(currentUser.uid).updateData([
            "pairRequestedUids": FieldValue.arrayRemove([requestedUser.uid]),
            "pairUid": requestedUser.uid,
        ])
        
        db.collection(userPath).document(requestedUser.uid).updateData([
            "pairRequestUid": "",
            "pairUid": currentUser.uid
        ])
        
        var ref: DocumentReference? = nil
        ref = db.collection(self.pairPath).addDocument(data: [
            //　ペアは同性としか組めないので、一方のユーザの性別から取得で良い。
            "gender": currentUser.gender,
            "pair_1_uid": currentUser.uid,
            "pair_1_nickname": currentUser.nickname,
            "pair_1_profileImageURL": currentUser.profileImageURL,
            "pair_1_birthDate": currentUser.birthDate,
            "pair_1_activeRegion": currentUser.activeRegion,
            "pair_2_uid": requestedUser.uid,
            "pair_2_nickname": requestedUser.nickname,
            "pair_2_profileImageURL": requestedUser.profileImageURL,
            "pair_2_birthDate": requestedUser.birthDate,
            "pair_2_activeRegion": requestedUser.activeRegion
        ]){ error in
            if let error = error {
                print(error)
            } else{
                guard let ref = ref else { return }
                db.collection(self.userPath).document(currentUser.uid).updateData([
                    "pairID": ref.documentID,
                    "pairList": [requestedUser.uid: ref.documentID]
                ])
                db.collection(self.userPath).document(requestedUser.uid).updateData([
                    "pairID": ref.documentID,
                    "pairList": [currentUser.uid: ref.documentID]
                ])
            }
        }
    }
    
    func changePair(
        currentUser: UserObservableModel,
        pairUser: UserObservableModel
    ) {
        let currentUserDocRef = db.collection(userPath).document(currentUser.uid)
        let pairUserDocRef = db.collection(userPath).document(pairUser.uid)
        let pairDocRef = db.collection(pairPath).document(currentUser.pairID)
        let pastPairDocRef = db.collection(pastPairPath).document(currentUser.pairID)
        
        db.runTransaction ({ (transaction, error) -> Void in
            let pairDoc: DocumentSnapshot
            do {
                try pairDoc = transaction.getDocument(pairDocRef)
            } catch let fetchError as NSError {
                error?.pointee = fetchError
                return
            }
            
            guard let pairDoc = pairDoc.data() else {
                let domainError = NSError(
                    domain: "AppErrorDomain",
                    code: -1,
                    userInfo: [
                        NSLocalizedDescriptionKey: "Unable to retrieve data from snapshot \(pairDoc)"
                    ]
                )
                error?.pointee = domainError
                return
            }
            transaction.setData(pairDoc, forDocument: pastPairDocRef)
            transaction.deleteDocument(pairDocRef)
            
            transaction.updateData([
                "pairID":"",
                "pairUid": "",
                "pastPairIDs": FieldValue.arrayUnion([currentUser.pairID])
            ], forDocument: currentUserDocRef)
            
            transaction.updateData([
                "pairID":"",
                "pairUid": "",
                "pastPairIDs": FieldValue.arrayUnion([currentUser.pairID])
            ], forDocument: pairUserDocRef)
            
        }) { object, error in
            if let error = error {
                print("Transaction failed: \(error)")
            } else {
                print("Transaction successfully committed!")
            }
        }
    }
    
    func purchaseCoins(uid: String, increaseCoins: Int) {
        db.collection(userPath).document(uid).updateData([
            "coins": FieldValue.increment(Int64(increaseCoins))
        ])
    }
    
    func updateHobbies(uid: String, hobbies: [String]) {
        db.collection(userPath).document(uid).updateData([
            "hobbies": hobbies
        ])
    }
    
    func updateDetailProfile(uid: String, fieldName:String, value: String, completion: @escaping () -> Void){
        db.collection(userPath).document(uid).updateData([
            fieldName: value
        ]){ error in
            if let error = error {
                // Errorハンドリングを作る！！
                print(error)
                return
            }
            completion()
        }
    }
    
    func updateProfileImages(currentUser: UserObservableModel, pair: PairObservableModel){
        let batch = db.batch()
        let userDocRef = db.collection(userPath).document(currentUser.uid)
        let pairDocRef = db.collection(pairPath).document(currentUser.pairID)
        
        batch.updateData([
            "profileImageURL": currentUser.profileImageURL,
            "subProfileImageURLs": currentUser.subProfileImageURL
        ], forDocument: userDocRef)
        
        if currentUser.pairUid != "" {
            if pair.pair.pair_1_uid == currentUser.uid {
                batch.updateData([
                    "pair_1_profileImageURL": currentUser.profileImageURL
                ], forDocument: pairDocRef)
            } else {
                batch.updateData([
                    "pair_2_profileImageURL": currentUser.profileImageURL
                ], forDocument: pairDocRef)
            }
        }
        
        batch.commit { error in
            if let error = error {
                print(error)
                // エラーアラートを出す。
            } else {
                print("Friend successfully updated!")
            }
        }
    }
    
    // この関数は10コイン以上あるユーザーしか呼べない。
    func makeChat(
        requestPairID: String,
        requestedPairID: String,
        message: String,
        sendUserInfo: UserObservableModel,
        currentPairUserID:String,
        currentChatPairUserID_1:String,
        currentChatPairUserID_2:String,
        recieveNotificatonTokens:[String],
        createdAt: Date,
        completion: @escaping(String)->()
    ){
        let timestamp = Timestamp(date: createdAt)
        let chatDocumentID = UUID().uuidString
        
        let batch = db.batch()
        
        let chatDoc = db.collection(chatPath).document(chatDocumentID)
        let messageDoc = db.collection(chatPath).document(chatDocumentID).collection(messagePath).document(UUID().uuidString)
        
        let requestedPairDoc = db.collection(pairPath).document(requestedPairID)
        let requestPairDoc = db.collection(pairPath).document(requestPairID)
        
        let currentUserDoc = db.collection(userPath).document(sendUserInfo.uid)
        let currentPairUserDoc = db.collection(userPath).document(currentPairUserID)
        let currentChatPairUserID_1_Doc = db.collection(userPath).document(currentChatPairUserID_1)
        let currentChatPairUserID_2_Doc = db.collection(userPath).document(currentChatPairUserID_2)
        
        batch.setData([
            "pairs": FieldValue.arrayUnion([requestedPairID, requestPairID])
        ], forDocument: chatDoc)
        
        batch.setData([
            "sendUserID": sendUserInfo.uid,
            "sendUserNickname": sendUserInfo.nickname,
            "sendUserProfileImageURL": sendUserInfo.profileImageURL,
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
                print(error)
                // エラーアラートを出す。
            } else {
                completion(chatDocumentID)
            }
        }
    }
    
    
    func sendMessage(
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
    ){
        let timestamp = Timestamp(date: createdAt)
        // 途中で処理が失敗すると整合性が取れなくなるためバッチ処理。
        let batch = db.batch()
        
        let messageDoc = db.collection(chatPath).document(chatRoomID).collection(messagePath).document(UUID().uuidString)
        
        let currentUserPairDoc = db.collection(pairPath).document(currentUserPairID)
        let chatPairDoc = db.collection(pairPath).document(chatPairID)
        
        let currentUserDoc = db.collection(userPath).document(user.uid)
        let currentPairUserDoc = db.collection(userPath).document(currentPairUserID)
        let currentChatPairUserID_1_Doc = db.collection(userPath).document(currentChatPairUserID_1)
        let currentChatPairUserID_2_Doc = db.collection(userPath).document(currentChatPairUserID_2)
        
        batch.setData([
            "sendUserID": user.uid,
            "sendUserNickname": user.nickname,
            "sendUserProfileImageURL": user.profileImageURL,
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
                print(error)
                // エラーアラートを出す。
            } else {
                print("Message Successfull Send!")
            }
        }
    }
}
