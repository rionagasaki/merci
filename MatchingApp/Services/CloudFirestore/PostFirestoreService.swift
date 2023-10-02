//
//  PostFirestoreService.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/08/21.
//

import Foundation
import Combine
import FirebaseFirestore

enum PostTarget {
    case all
    case friend
    case `init`
}

class PostFirestoreService {
    let userPath: String = "User"
    let likeNoticePath: String = "LikeNotice"
    let commentNoticePath: String = "CommentNotice"
    let postPath: String = "Post"
    let secretText: String = "SecretText"
    private var lastDocument: DocumentSnapshot?
    private var friendLastDocument: DocumentSnapshot?
    private var usersLastDocument: DocumentSnapshot?
    
    func getAllPost(startAfter lastDoc: DocumentSnapshot? = nil, target: PostTarget) -> AnyPublisher<[Post], AppError> {
        return Future { promise in
            var query: Query = db
                .collection(self.postPath)
                .order(by: "createdAt", descending: true)
                .limit(to: 20)
            
            if let lastDoc = lastDoc {
                query = query.start(afterDocument: lastDoc)
            }
            
            query.getDocuments { (querySnapshots, error) in
                if let error = error {
                    promise(.failure(.firestore(error)))
                } else if let querySnapshots = querySnapshots {
                    let posts = querySnapshots.documents.map { document -> Post in
                        return Post(document: document)
                    }
                    switch target {
                    case .all:
                        if querySnapshots.documents.count < 20 {
                            self.lastDocument = nil
                        } else {
                            self.lastDocument = querySnapshots.documents.last
                        }
                    case .friend:
                        if querySnapshots.documents.count < 20 {
                            self.friendLastDocument = nil
                        } else {
                            self.friendLastDocument = querySnapshots.documents.last
                        }
                   
                    case .`init`:
                        if querySnapshots.documents.count < 20 {
                            self.lastDocument = nil
                            self.friendLastDocument = nil
                        } else {
                            self.lastDocument = querySnapshots.documents.last
                            self.friendLastDocument = querySnapshots.documents.last
                        }
                    }
                    promise(.success(posts))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func getNextPage() -> AnyPublisher<[Post], AppError> {
        return getAllPost(startAfter: self.lastDocument, target: .all)
    }
    
    func getFriendNextPage() -> AnyPublisher<[Post], AppError> {
        return getAllPost(startAfter: self.friendLastDocument, target: .friend)
    }
    
    func getOnePost(postId: String) -> AnyPublisher<Post, AppError> {
        return Future { promise in
            db.collection(self.postPath).document(postId).getDocument { document, error in
                if let error = error {
                    promise(.failure(.firestore(error)))
                    return
                }
                guard let document = document else {
                    promise(.failure(.other(.unexpectedError)))
                    return
                }
                let postData = Post(document: document)
                return promise(.success(postData))
            }
        }.eraseToAnyPublisher()
    }
    
    func getPostsConcurrentlly(postIds:[String]) -> AnyPublisher<[Post], AppError> {
        let publishers = postIds.map { getOnePost(postId: $0) }
        
        return Publishers.MergeMany(publishers)
            .collect()
            .eraseToAnyPublisher()
    }
    
    func getUserPost(userID: String, startAfter lastDoc: DocumentSnapshot? = nil) -> AnyPublisher<[Post], AppError> {
        return Future { promise in
            var query: Query = db
                .collection(self.postPath)
                .whereField("posterUid", isEqualTo: userID)
                .order(by: "createdAt", descending: true)
                .limit(to: 20)
            
            if let lastDoc = lastDoc {
                query = query.start(afterDocument: lastDoc)
            }
            query.getDocuments { querySnapshots, error in
                if let error = error {
                    print(error)
                    promise(.failure(.firestore(error)))
                } else {
                    if let querySnapshots = querySnapshots {
                        let posts = querySnapshots.documents.map { document -> Post in
                            return Post(document: document)
                        }
                        if querySnapshots.documents.count < 20 {
                            self.usersLastDocument = nil
                        } else {
                            self.usersLastDocument = querySnapshots.documents.last
                        }
                        promise(.success(posts))
                    }
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func getNextUsersPost(userId: String) -> AnyPublisher<[Post], AppError> {
        return getUserPost(userID: userId, startAfter: self.usersLastDocument)
    }
    
    func createPost (
        createdAt: Date,
        posterUid: String,
        posterNickName: String,
        posterProfileImageUrlString: String,
        text: String,
        contentImageUrlStrings:[String]
    ) -> AnyPublisher<Void, AppError>{
        let postId = UUID().uuidString
        return Future { promise in
            db.collection(self.postPath).document(postId).setData([
                "createdAt": createdAt,
                "posterUid": posterUid,
                "posterNickName": posterNickName,
                "posterProfileImageUrlString": posterProfileImageUrlString,
                "text":text,
                "contentImageUrlStrings": contentImageUrlStrings
            ]){ error in
                if let error = error {
                    promise(.failure(.firestore(error)))
                } else {
                    promise(.success(()))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    func createReplyPost(
        fromUser: UserObservableModel,
        toUser: UserObservableModel,
        parentPost: PostObservableModel,
        text: String,
        contentImageUrlStrings:[String]
    ) -> AnyPublisher<Void, AppError> {
        return Future { promise in
            let postId = UUID().uuidString
            let batch = db.batch()
            let replyPostDocRef = db.collection(self.postPath).document(postId)
            let parentPostDocRef = db.collection(self.postPath).document(parentPost.id)
            let noticeID: String = UUID().uuidString
            let noticeDoc = db.collection(self.userPath).document(toUser.user.uid).collection(self.commentNoticePath).document(noticeID)
            let allParentPost = parentPost.parentPosts + [parentPost.id]
            batch.setData([
                "createdAt": Date.init(),
                "posterUid": fromUser.user.uid,
                "posterNickName": fromUser.user.nickname,
                "posterProfileImageUrlString": fromUser.user.profileImageURLString,
                "text":text,
                "contentImageUrlStrings": contentImageUrlStrings,
                "mentionUserUid": toUser.user.uid,
                "mentionUserNickName": toUser.user.nickname,
                "parentPosts": allParentPost
            ], forDocument: replyPostDocRef)
            
            batch.setData([
                "replys": [fromUser.user.uid : postId],
                "childPosts": FieldValue.arrayUnion([postId])
            ], forDocument: parentPostDocRef, merge: true)
            
            batch.setData([
                "createdAt": Date.init(),
                "isRead": false,
                "recieverUserId": toUser.user.uid,
                "recieverUserFcmToken": toUser.user.fcmToken,
                "recieverPostId": parentPost.id,
                "recieverPostText": parentPost.text,
                "triggerUserNickNameMapping": [fromUser.user.uid: fromUser.user.nickname],
                "triggerUserProfileImageUrlStringMapping": [fromUser.user.uid: fromUser.user.profileImageURLString],
                "lastTriggerUserUid": fromUser.user.uid,
                "lastTriggerCommentText": text,
            ], forDocument: noticeDoc)
            
            batch.setData([
                "commentNotice": toUser.user.uid
            ], forDocument: noticeDoc, merge: true)
            
            batch.commit {error in
                if let error = error {
                    promise(.failure(.firestore(error)))
                } else {
                    promise(.success(()))
                }
            }
            
        }.eraseToAnyPublisher()
    }
    
    func handleLikeButtonPress(userModel: UserObservableModel, postModel: PostObservableModel) -> Future<Void, AppError> {
        return Future { promise in
            let batch = db.batch()
            let noticeDocRef = db.collection(self.userPath).document(postModel.posterUid).collection(self.likeNoticePath).document(postModel.id)
            let postDocRef = db.collection(self.postPath).document(postModel.id)
            
            if (postModel.likes[userModel.user.uid] == nil) {
                
                batch.updateData([
                    "likes.\(userModel.user.uid)": userModel.user.profileImageURLString
                ], forDocument: postDocRef)
                
                if userModel.user.uid != postModel.posterUid {
                    batch.setData([
                        "createdAt": Date.init(),
                        "recieverUserId": postModel.posterUid,
                        "recieverPostId": postModel.id,
                        "recieverPostText": postModel.text,
                        "triggerUserNickNameMapping": [userModel.user.uid: userModel.user.nickname],
                        "triggerUserProfileImageUrlStringMapping": [userModel.user.uid: userModel.user.profileImageURLString],
                        "lastTriggerUserUid": userModel.user.uid
                    ], forDocument: noticeDocRef, merge: true)
                }
                
                batch.commit { error in
                    if let error = error {
                        promise(.failure(.firestore(error)))
                    } else {
                        promise(.success(()))
                    }
                }
            } else {
                
                batch.updateData([
                    "likes.\(userModel.user.uid)": FieldValue.delete()
                ], forDocument: postDocRef)
                
                batch.commit { error in
                    if let error = error {
                        promise(.failure(.firestore(error)))
                    } else {
                        promise(.success(()))
                    }
                }
            }
        }
    }
    
    func deletePost(postID: String, userID: String, fixedPostID: String) -> AnyPublisher<Void, AppError> {
        let batch = db.batch()
        let postDocRef = db.collection(self.postPath).document(postID)
        let userDocRef = db.collection(self.userPath).document(userID)
        return Future { promise in
            batch.deleteDocument(postDocRef)
            
            if fixedPostID == postID {
                batch.updateData([
                    "fixedPost": ""
                ], forDocument: userDocRef)
            }
            
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
