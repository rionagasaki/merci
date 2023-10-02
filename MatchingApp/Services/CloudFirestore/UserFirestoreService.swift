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
    func getOnlineUser(userID: String) -> AnyPublisher<[UserModel], AppError> {
        return Future { promise in
            db.collection(self.userPath).whereField("status", isEqualTo: "online")
                .getDocuments { querySnapshot, error in
                    if let error = error {
                        promise(.failure(.firestore(error)))
                    } else if let querySnapshot = querySnapshot {
                        let userModel = querySnapshot.documents.map { document in
                            return User(document: document).adaptUserObservableModel()
                        }.filter { user in
                            user.uid != userID
                        }
                        promise(.success(userModel))
                    }
                }
            
        }.eraseToAnyPublisher()
    }
    
    func searchUser(uid: String) -> AnyPublisher<User?, AppError>{
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
    
    func getConcurrentUserInfo(userIDs: [String]) -> AnyPublisher<[User], AppError>{
        let publisher = userIDs.map { searchUser(uid: $0) }
        return Publishers.MergeMany(publisher).compactMap { $0 }.collect().eraseToAnyPublisher()
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
    
    func checkAccountExists(email: String, isNewUser: Bool) -> AnyPublisher<Void, AppError>{
        return Future { promise in
            db.collection("User")
                .whereField("email", isEqualTo: email)
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
    
    func registerUserEmailAndUid(email: String, uid: String) -> AnyPublisher<Void, AppError> {
        return Future { promise in
            db.collection(self.userPath).document(uid).setData([
                "uid": uid,
                "email": email
            ]){ error in
                if let error = error {
                    promise(.failure(.firestore(error)))
                } else {
                    promise(.success(()))
                }
            }
        }.eraseToAnyPublisher()
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
    ) -> AnyPublisher<Void, AppError> {
        return Future { promise in
            db.collection(self.userPath).document(currentUid).updateData([
                key: value
            ]){ error in
                if let error = error {
                    promise(.failure(.firestore(error)))
                } else {
                    promise(.success(()))
                }
            }
        }.eraseToAnyPublisher()
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
    
    func fixedPostToProfile(postID: String, userID: String) -> AnyPublisher<Void, AppError> {
        return Future { promise in
            db.collection(self.userPath).document(userID).updateData([
                "fixedPost": postID
            ]){ error in
                if let error = error {
                    promise(.failure(.firestore(error)))
                } else {
                    promise(.success(()))
                }
            }
        }.eraseToAnyPublisher()
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
}
