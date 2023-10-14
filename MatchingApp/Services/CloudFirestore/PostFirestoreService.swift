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

final class PostFirestoreService {
    private let userPath: String = "User"
    private let likeNoticePath: String = "LikeNotice"
    private let commentNoticePath: String = "CommentNotice"
    private let postPath: String = "Post"
    private let postReportPath: String = "PostReport"
    
    private var lastDocument: DocumentSnapshot?
    private var friendLastDocument: DocumentSnapshot?
    private var usersLastDocument: DocumentSnapshot?
    private let createdAt: String = "createdAt"
    private let queryLimit = 20
    
    func getAllPost(startAfter lastDoc: DocumentSnapshot? = nil, target: PostTarget) async throws -> [Post] {
        let querySnapshots = try await createQuery(startAfter: lastDoc).getDocuments()
        updateLastDocumentBasedOn(target: target, with: querySnapshots)
        return querySnapshots.documents.map { Post(document: $0) }
    }
    
    private func createQuery(startAfter lastDoc: DocumentSnapshot?) -> Query {
        var query: Query = db
            .collection(self.postPath)
            .order(by: createdAt, descending: true)
            .limit(to: queryLimit)
        
        if let lastDoc = lastDoc {
            query = query.start(afterDocument: lastDoc)
        }
        return query
    }
    
    private func updateLastDocumentBasedOn(target: PostTarget, with snapshots: QuerySnapshot) {
        let shouldReset = snapshots.documents.count < queryLimit
        
        switch target {
        case .all:
            self.lastDocument = shouldReset ? nil : snapshots.documents.last
        case .friend:
            self.friendLastDocument = shouldReset ? nil : snapshots.documents.last
        case .`init`:
            self.lastDocument = shouldReset ? nil : snapshots.documents.last
            self.friendLastDocument = shouldReset ? nil : snapshots.documents.last
        }
    }
    
    
    func getNextPage() async throws -> [Post] {
        let posts = try await getAllPost(startAfter: self.lastDocument, target: .all)
        return posts
    }
    
    func getFriendNextPage() async throws  -> [Post] {
        let posts = try await getAllPost(startAfter: self.friendLastDocument, target: .friend)
        return posts
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
                .order(by: self.createdAt, descending: true)
                .limit(to: self.queryLimit)
            
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
                        if querySnapshots.documents.count < self.queryLimit {
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
    ) async throws -> Void {
        let postId = UUID().uuidString
        try await db.collection(self.postPath).document(postId).setData([
            "createdAt": createdAt,
            "posterUid": posterUid,
            "posterNickName": posterNickName,
            "posterProfileImageUrlString": posterProfileImageUrlString,
            "text":text,
            "contentImageUrlStrings": contentImageUrlStrings
        ])
    }
    
    func createReplyPost(
        fromUser: UserObservableModel,
        toUser: UserObservableModel,
        parentPost: PostObservableModel,
        text: String,
        contentImageUrlStrings:[String]
    ) async throws {
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
        
        try await batch.commit()
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
    
    func deletePost(postID: String, userID: String, fixedPostID: String) async throws {
        let batch = db.batch()
        let postDocRef = db.collection(self.postPath).document(postID)
        let userDocRef = db.collection(self.userPath).document(userID)
        
        batch.deleteDocument(postDocRef)
        
        if fixedPostID == postID {
            batch.updateData([
                "fixedPost": ""
            ], forDocument: userDocRef)
        }
        try await batch.commit()
    }
    
    func addReportToPost(fromUserID: String, toUserID:String, postID: String, postText: String, reportText: String) async throws -> Void {
        let reportID = UUID().uuidString
        try await  db.collection(self.postReportPath).document(reportID).setData([
            "createdAt": Date.init(),
            "fromUserID": fromUserID,
            "toUserID": toUserID,
            "postID": postID,
            "postText": postText,
            "reportText": reportText
        ])
    }
}
