//
//  NoticeFirestoreService.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/08/21.
//

import Foundation
import FirebaseFirestore
import Combine
class NoticeFirestoreService {
    
    let reportPath = "Report"
    let userPath = "User"
    let likeNoticePath = "LikeNotice"
    let commentNoticePath = "CommentNotice"
    let requestNoticePath = "RequestNotice"
    
    
    func createReport(reportUserID: String, reportedUserID: [String], reportText: String) -> AnyPublisher<Void, AppError>{
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
    
    func getLikeNoticeInfo(userID: String) -> AnyPublisher<[LikeNoticeObservableModel], AppError>{
        return Future { promise in
            db.collection(self.userPath).document(userID).collection(self.likeNoticePath).order(by: "createdAt", descending: true).getDocuments { querySnapshots, error in
                if let error = error {
                    promise(.failure(.firestore(error)))
                    return
                }
                guard let querySnapshots = querySnapshots else {
                    promise(.failure(.other(.unexpectedError)))
                    return
                }
                
                var notices:[LikeNoticeObservableModel] = []
                notices = querySnapshots.documents.map { document in
                    let notice = LikeNotice(document: document)
                    return notice.adaptNoticeObservableModel()
                }
                return promise(.success(notices))
            }
        }.eraseToAnyPublisher()
    }
    
    func getCommentNoticeInfo(userID: String) -> AnyPublisher<[CommentNoticeObservableModel], AppError>{
        return Future { promise in
            db.collection(self.userPath).document(userID).collection(self.commentNoticePath).order(by: "createdAt", descending: true).getDocuments { querySnapshots, error in
                if let error = error {
                    promise(.failure(.firestore(error)))
                    return
                }
                guard let querySnapshots = querySnapshots else {
                    promise(.failure(.other(.unexpectedError)))
                    return
                }
                var notices:[CommentNoticeObservableModel] = []
                notices = querySnapshots.documents.map { document in
                    let notice = CommentNotice(document: document)
                    return notice.adaptNoticeObservableModel()
                }
                return promise(.success(notices))
            }
        }.eraseToAnyPublisher()
    }
    
    func getRequestNoticeInfo(userID: String) -> AnyPublisher<[RequestNoticeObservableModel], AppError>{
        return Future { promise in
            db
                .collection(self.userPath)
                .document(userID)
                .collection(self.requestNoticePath)
                .order(by: "createdAt", descending: true)
                .getDocuments { querySnapshots, error in
                    
                if let error = error {
                    promise(.failure(.firestore(error)))
                    return
                }
                guard let querySnapshots = querySnapshots else {
                    promise(.failure(.other(.unexpectedError)))
                    return
                }
                var notices:[RequestNoticeObservableModel] = []
                notices = querySnapshots.documents.map { document in
                    let notice = RequestNotice(document: document)
                    return notice.adaptNoticeObservableModel()
                }
                return promise(.success(notices))
            }
        }.eraseToAnyPublisher()
    }
    
    func getAllNotices(userID: String) -> AnyPublisher<(likeNotices: [LikeNoticeObservableModel], commentNotices: [CommentNoticeObservableModel], requestNotices: [RequestNoticeObservableModel]), AppError> {
        let likeNoticePublisher = getLikeNoticeInfo(userID: userID)
        let commentNoticePublisher = getCommentNoticeInfo(userID: userID)
        let requestNoticePublisher = getRequestNoticeInfo(userID: userID)
        
        return Publishers.Zip3(likeNoticePublisher, commentNoticePublisher, requestNoticePublisher)
            .map { (likeNotices, commentNotices, requestNotices) in
                return (likeNotices: likeNotices, commentNotices: commentNotices, requestNotices: requestNotices)
            }
            .eraseToAnyPublisher()
    }
    
    func updateReadStatus(noticeType: String, userID: String, noticeID: String) -> AnyPublisher<Void, AppError> {
        return Future { promise in
            db.collection(self.userPath).document(userID).collection(noticeType).document(noticeID).updateData([
                "isRead" : true
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
