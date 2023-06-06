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
    let chatPath:String = "Chat"
    let messagePath: String = "Message"
    
    func registerUserInfoFirestore(uid: String, nickname: String, email: String, profileImageURL: String,gender:String,activityRegion: String, birthDate: String, completion: @escaping ()-> Void){
        db.collection(userPath).document(uid).setData([
            "nickname": nickname,
            "email": email,
            "profileImageURL": profileImageURL,
            "gender": gender,
            "activityRegion": activityRegion,
            "birthDate": birthDate,
        ]){ err in
            if let err = err {
                print("Error=>registerUserInfoFirestore:\(String(describing: err))")
            } else {
                completion()
            }
        }
    }
    
    func requestPair(currentUid: String, pairUserUid: String){
        db.collection(userPath).document(currentUid).updateData([
            "requestUid": FieldValue.arrayUnion([pairUserUid])
        ])
        
        db.collection(userPath).document(pairUserUid).updateData([
            "requestedUid": FieldValue.arrayUnion([currentUid])
        ])
    }
    
    func allowRequest(currentUid: String, pairUserUid: String){
        db.collection(userPath).document(currentUid).updateData([
            "requestedUid": FieldValue.arrayRemove([pairUserUid])
        ])
        
        db.collection(userPath).document(pairUserUid).updateData([
            "requestUid": FieldValue.arrayRemove([currentUid])
        ])
    }
    
    func updateMyIntroduction(currentUid: String,introduction: String){
        db.collection(userPath).document(currentUid).updateData([
            "introduction": introduction
        ])
    }
    
    func updatePair(currentUser:UserObservableModel, requestedUid: String){
        // リクエストされて承認した側
        db.collection(userPath).document(currentUser.uid).updateData([
            "requestedUid": FieldValue.arrayRemove([requestedUid]),
            "pairUid": requestedUid
        ])
        
        // リクエストした側のDBをいじる(現在ログインしているユーザから見れば、requestedUidを持つユーザ)
        db.collection(userPath).document(requestedUid).updateData([
            "requestUid": FieldValue.arrayRemove([currentUser.uid]),
            "pairUid": currentUser.uid
        ])
        
        FetchFromFirestore().fetchUserInfoFromFirestoreByUserID(uid: requestedUid) { user in
            guard let user = user else { return }
            var ref: DocumentReference? = nil
            ref = db.collection(self.pairPath).addDocument(data: [
                //　ペアは同性としか組めないので、一方のユーザの性別から取得で良い。
                "gender": currentUser.gender,
                "pair_1_uid": currentUser.uid,
                "pair_1_nickname": currentUser.nickname,
                "pair_1_profileImageURL": currentUser.profileImageURL,
                "pair_1_birthDate": currentUser.birthDate,
                "pair_1_activeRegion": currentUser.activeRegion,
                "pair_2_uid": user.id,
                "pair_2_nickname": user.nickname,
                "pair_2_profileImageURL": user.profileImageURL,
                "pair_2_birthDate": user.birthDate,
                "pair_2_activeRegion": user.activityRegion
            ]){ error in
                if let error = error {
                    print(error)
                } else{
                    guard let ref = ref else { return }
                    db.collection(self.userPath).document(currentUser.uid).updateData([
                        "pairID": ref.documentID
                    ])
                }
            }
        }
    }
    
    func updateHobbies(uid: String,hobbies: [String]) {
        db.collection(userPath).document(uid).updateData([
            "hobbies": hobbies
        ])
    }
    
    func updateProfileImages(uid: String, profileImageURL: String, subImageURLs:[String]){
        db.collection(userPath).document(uid).updateData([
            "profileImageURL": profileImageURL,
            "subProfileImageURLs": subImageURLs
        ])
    }
    
    
    func makeChat(requestPairID: String, requestedPairID: String, message: String, sendUserID: String){
        var ref: DocumentReference? = nil
        
        
        ref = db.collection(chatPath).addDocument(data: [
            "pairs": FieldValue.arrayUnion([requestedPairID, requestPairID])
        ])
        
        ref!.collection(messagePath).addDocument(data: [
            "sendUserID": sendUserID,
            "message": message
        ]){ _ in
            
            db.collection(self.pairPath).document(requestedPairID).updateData([
                "chatPairIDs": [requestPairID: ref?.documentID as Any]
            ])
            
            db.collection(self.pairPath).document(requestPairID).updateData([
                "chatPairIDs": [requestedPairID: ref?.documentID as Any]
            ])
        }
    }
    
    func sendMessage(chatRoomID: String,pairID: String, sendUserID: String,sendUserNickname: String, sendUserProfileImageURL: String, createdAt:Date , message: String){
        let timestamp = Timestamp(date: createdAt)
        db.collection(chatPath).document(chatRoomID).collection(messagePath).addDocument(data: [
            "sendUserID": sendUserID,
            "sendUserNickname": sendUserNickname,
            "sendUserProfileImageURL": sendUserProfileImageURL,
            "message": message,
            "createdAt": timestamp,
        ])
        
        db.collection(pairPath).document(pairID).updateData([
            "chatPairLastMessage": [pairID: message],
            "chatPairLastCreatedAt": [pairID: timestamp]
        ])
    }
}
