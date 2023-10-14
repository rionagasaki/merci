//
//  UserFirestoreService.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/08/21.
//

import Foundation
import Combine
import FirebaseFirestore

class UserFirestoreService {
    let userPath: String = "User"
    let requestNoticePath: String = "RequestNotice"
    let likePath: String = "Like"
    private var authenticationManager = AuthenticationManager.shared
    
    func getUser(uid: String) -> AnyPublisher<UserModel, AppError> {
        return Future { promise in
            db.collection(self.userPath).document(uid).getDocument { document, error in
                if let error = error {
                    print("Error=>fetchUserInfoFromFirestore:\(error)")
                    return
                }
                guard let document = document else {
                    promise(.failure(.other(.unexpectedError)))
                    return
                }
                let user = User(document: document).adaptUserObservableModel()
                promise(.success(user))
            }
        }.eraseToAnyPublisher()
    }
    func getOnlineUser(userID: String) async throws -> [UserModel] {
        let querySnapshot = try await db.collection(self.userPath).whereField("status", isEqualTo: "online")
            .getDocuments()
        let userModel = querySnapshot.documents.map { document in
            return User(document: document).adaptUserObservableModel()
        }.filter { user in
            user.uid != userID
        }
        return userModel
    }
    
    func getOneUser(uid: String) async throws -> User {
        let document = try await db.collection(self.userPath).document(uid).getDocument()
        let user = User(document: document)
        return user
    }
    
    func getConcurrentUserInfo(userIDs: [String]) async throws -> [User]  {
        var users: [User] = []
        return try await withThrowingTaskGroup(of: User.self, body: { group in
            for userID in userIDs {
                group.addTask {
                    return try await self.getOneUser(uid: userID)
                }
            }
            for try await user in group {
                users.append(user)
            }
            return users
        })
    }
    
    func getUpdateUser(uid: String, completion: @escaping (Result<UserModel, AppError>) -> Void) {
        FirestoreListener.shared.userListener?.remove()
        FirestoreListener.shared.userListener = db.collection(self.userPath).document(uid).addSnapshotListener { document, error in
            if let error = error {
                completion(.failure(.firestore(error)))
                return
            }
            guard let document = document else {
                completion(.failure(.other(.unexpectedError)))
                return
            }
            let userModel = User(document: document).adaptUserObservableModel()
            completion(.success(userModel))
        }
    }
    
    func checkAccountExists(email: String, isNewUser: Bool) async throws -> Void {
        let query = db.collection("User").whereField("email", isEqualTo: email)
        let snapshots = try await query.getDocuments()
        if isNewUser {
            if snapshots.count != 0 {
                throw AppError.other(.alreadyHasAccountError)
            }
        } else {
            if snapshots.count == 0 {
                throw AppError.other(.hasNoAccountError)
            }
        }
    }
    
    func registerUserEmailAndUid(email: String, uid: String) async throws {
        try await db.collection(self.userPath).document(uid).setData([
            "uid": uid,
            "email": email
        ])
    }
    
    func createUser(
        userInfo: UserObservableModel, completionHandler: @escaping (Result<Void, AppError>)->Void) {
            db.collection(self.userPath).document(userInfo.user.uid).setData([
                "nickname": userInfo.user.nickname,
                "email": userInfo.user.email,
                "gender": userInfo.user.gender,
                "profileImageURL": userInfo.user.profileImageURLString,
                "hobbies": ["初心者"],
                "onboarding": false
            ]){ error in
                if let error = error {
                    completionHandler(.failure(.firestore(error)))
                } else {
                    completionHandler(.success(()))
                }
            }
        }
    
    func updateUserInfo<T>(
        currentUid: String,
        key: String,
        value: T
    ) async throws -> Void {
        try await db.collection(self.userPath).document(currentUid).updateData([
            key: value
        ])
    }
    
    func updateProfileImageForUser(
        currentUser: UserObservableModel,
        selectedImage: String
    ) -> AnyPublisher<Void, AppError>{
        let batch = db.batch()
        let userDocRef = db.collection(self.userPath).document(currentUser.user.uid)
        
        return Future { promise in
            batch.updateData([
                "profileImageURL": selectedImage,
            ], forDocument: userDocRef)
            
            batch.commit { error in
                if let error = error as? NSError {
                    promise(.failure(.firestore(error)))
                } else {
                    promise(.success(()))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func fixedPostToProfile(postID: String, userID: String) async throws -> Void {
        try await db.collection(self.userPath).document(userID).updateData([
            "fixedPost": postID
        ])
    }
    
    func requestFriend(
        requestingUser: UserObservableModel,
        requestedUser: UserObservableModel
    ) -> AnyPublisher<Void, AppError> {
        return Future { promise in
            let batch = db.batch()
            
            let fromUserDoc = db.collection(self.userPath).document(requestingUser.user.uid)
            let toUserDoc = db.collection(self.userPath).document(requestedUser.user.uid)
            let noticeDocId = UUID().uuidString
            let toUserNoticeDoc = toUserDoc.collection(self.requestNoticePath).document(noticeDocId)
            
            batch.updateData([
                "friendRequestUids": FieldValue.arrayUnion([requestedUser.user.uid])
            ], forDocument: fromUserDoc)
            
            batch.setData([
                "type": RequestNoticeType.request.rawValue,
                "createdAt": Date.init(),
                "isRead": false,
                "recieverUserId": requestedUser.user.uid,
                "recieverUserFcmToken": requestedUser.user.fcmToken,
                "triggerUserUid": requestingUser.user.uid,
                "triggerUserNickName": requestingUser.user.nickname,
                "triggerUserProfileImageUrlString": requestingUser.user.profileImageURLString,
            ], forDocument: toUserNoticeDoc, merge: true)
            
            batch.updateData([
                "friendRequestedUids": FieldValue.arrayUnion([requestingUser.user.uid])
            ], forDocument: toUserDoc)
            
            batch.commit { error in
                if let error = error as? NSError {
                    promise(.failure(.firestore(error)))
                } else {
                    promise(.success(()))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func cancelFriendRequest (
        requestingUser: UserObservableModel,
        requestedUser: UserObservableModel
    ) -> AnyPublisher<Void, AppError> {
        return Future { promise in
            let batch = db.batch()
            db.collection(self.userPath).document(requestedUser.user.uid).collection(self.requestNoticePath).whereField("triggerUserUid", isEqualTo: requestingUser.user.uid).getDocuments { querySnapshot, error in
                if let error = error {
                    promise(.failure(.firestore(error)))
                } else {
                    if let querySnapshot = querySnapshot {
                        querySnapshot.documents.forEach { document in
                            document.reference.delete()
                        }
                    }
                }
            }
            let currentUserDoc = db.collection(self.userPath).document(requestingUser.user.uid)
            batch.updateData([
                "friendRequestUids": FieldValue.arrayRemove([requestedUser.user.uid])
            ], forDocument: currentUserDoc)
            
            let pairUserDoc = db.collection(self.userPath).document(requestedUser.user.uid)
            batch.updateData([
                "friendRequestedUids": FieldValue.arrayRemove([requestingUser.user.uid])
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
    
    func approveRequest(
        requestUser: UserObservableModel,
        requestedUser: UserObservableModel
    ) -> AnyPublisher<Void, AppError> {
        return Future { promise in
            let batch = db.batch()
            let noticeDocId: String = UUID().uuidString
            let fromUserDoc = db.collection(self.userPath).document(requestUser.user.uid)
            let toUserDoc = db.collection(self.userPath).document(requestedUser.user.uid)
            let toUserNoticeDoc = toUserDoc.collection(self.requestNoticePath).document(noticeDocId)
            
            batch.setData([
                "friendUids": FieldValue.arrayUnion([requestedUser.user.uid]),
                "friendRequestedUids": FieldValue.arrayRemove([requestedUser.user.uid])
            ], forDocument: fromUserDoc, merge: true)
            
            batch.setData([
                "friendUids": FieldValue.arrayUnion([requestUser.user.uid]),
                "friendRequestUids": FieldValue.arrayRemove([requestUser.user.uid]),
            ], forDocument: toUserDoc, merge: true)
            
            batch.setData([
                "type": RequestNoticeType.approve.rawValue,
                "createdAt": Date.init(),
                "isRead": false,
                "recieverUserId": requestUser.user.uid,
                "recieverUserFcmToken": requestedUser.user.fcmToken,
                "triggerUserUid": requestUser.user.uid,
                "triggerUserNickName": requestUser.user.nickname,
                "triggerUserProfileImageUrlString": requestUser.user.profileImageURLString,
            ], forDocument: toUserNoticeDoc)
            
            batch.commit { error in
                if let error = error as? NSError {
                    promise(.failure(.firestore(error)))
                } else {
                    promise(.success(()))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func deleteUser(
        requestingUser: UserObservableModel,
        requestedUser: UserObservableModel
    ) -> AnyPublisher<Void, AppError> {
        return Future { promise in
            let batch = db.batch()
            let fromUserDoc = db.collection(self.userPath).document(requestingUser.user.uid)
            let toUserDoc = db.collection(self.userPath).document(requestedUser.user.uid)
            
            batch.setData([
                "friendUids": FieldValue.arrayRemove([requestedUser.user.uid])
            ], forDocument: fromUserDoc, merge: true)
            
            batch.setData([
                "friendUids": FieldValue.arrayRemove([requestingUser.user.uid])
            ], forDocument: toUserDoc, merge: true)
            
            batch.commit { error in
                if let error = error as? NSError {
                    promise(.failure(.firestore(error)))
                } else {
                    promise(.success(()))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func blockUser(
        requestingUser: UserObservableModel,
        requestedUser:UserObservableModel
    ) -> AnyPublisher<Void, AppError> {
        let batch = db.batch()
        let fromUserDoc = db.collection(self.userPath).document(requestingUser.user.uid)
        let toUserDoc = db.collection(self.userPath).document(requestedUser.user.uid)
        return Future { promise in
            batch.setData([
                "friendUids": FieldValue.arrayRemove([requestedUser.user.uid]),
                "blockingUids": FieldValue.arrayUnion([requestedUser.user.uid])
            ], forDocument: fromUserDoc, merge: true)
            
            batch.setData([
                "friendUids": FieldValue.arrayRemove([requestingUser.user.uid]),
                "blockedUids": FieldValue.arrayUnion([requestingUser.user.uid])
            ], forDocument: toUserDoc, merge: true)
            
            batch.commit { error in
                if let error = error as? NSError {
                    promise(.failure(.firestore(error)))
                } else {
                    promise(.success(()))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func resolveBlock(
        requestingUser: UserObservableModel,
        requestedUser: UserObservableModel
    ) -> AnyPublisher<Void, AppError> {
        let batch = db.batch()
        let requestingUserDocRef = db.collection(self.userPath).document(requestingUser.user.uid)
        let requestedUserDocRef = db.collection(self.userPath).document(requestedUser.user.uid)
        return Future { promise in
            batch.setData([
                "blockingUids": FieldValue.arrayRemove([requestedUser.user.uid])
            ], forDocument: requestingUserDocRef, merge: true)
            
            batch.setData([
                "blockedUids": FieldValue.arrayRemove([requestingUser.user.uid])
            ], forDocument: requestedUserDocRef, merge: true)
            
            batch.commit { error in
                if let error = error {
                    promise(.failure(.firestore(error)))
                } else {
                    promise(.success(()))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func updateUserCallingStatus(
        userID: String,
        completionHandler: @escaping(Result<Void, AppError>)->Void
    ){
        db.collection(self.userPath).document(userID).setData([
            "isCallingChannelId": ""
        ], merge: true){ error in
            if let error = error {
                completionHandler(.failure(.firestore(error)))
            } else {
                completionHandler(.success(()))
            }
        }
    }
    
    func updateChatRoomHidden(fromUserID: String, toUserID: String) -> AnyPublisher<Void, AppError> {
        return Future { promise in
            db.collection(self.userPath).document(fromUserID).updateData([
                "hiddenChatRoomUserIDs": FieldValue.arrayUnion([toUserID])
            ]) { error in
                if let error = error {
                    promise(.failure(.firestore(error)))
                } else {
                    promise(.success(()))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func resolveChatRoomHidden(fromUserID: String, toUserID: String) -> AnyPublisher<Void, AppError> {
        return Future { promise in
            db.collection(self.userPath).document(fromUserID).updateData([
                "hiddenChatRoomUserIDs": FieldValue.arrayRemove([toUserID])
            ]){ error in
                if let error = error {
                    promise(.failure(.firestore(error)))
                } else {
                    promise(.success(()))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func updateIsDisplayOnlyPost(userID: String, isDisplayOnlyPost: Bool, completionHandler: @escaping(Result<Void, AppError>)->Void){
        db.collection(self.userPath).document(userID).updateData([
            "isDisplayOnlyPost": isDisplayOnlyPost
        ]){ error in
            if let error = error {
                completionHandler(.failure(.firestore(error)))
            } else {
                completionHandler(.success(()))
            }
        }
    }
    
    func addHiddenPost(userID: String, postID: String) async throws -> Void {
        try await  db.collection(self.userPath).document(userID).updateData([
            "hiddenPostIDs": FieldValue.arrayUnion([postID])
        ])
    }
}
