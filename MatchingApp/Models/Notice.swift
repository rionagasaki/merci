//
//  Notice.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/07/21.
//
import Foundation
import FirebaseFirestore

class Notice {
    var id: String
    var recieverUserId: String
    var recieverUserFcmToken: String
    var createdAt: Timestamp
    var isRead: Bool
    
    init(document: QueryDocumentSnapshot){
        let noticeDic = document.data()
        self.id = document.documentID
        self.createdAt = (noticeDic["createdAt"] as? Timestamp ?? .init())
        self.recieverUserId = (noticeDic["recieverUserId"] as? String).orEmpty
        self.recieverUserFcmToken = (noticeDic["recieverUserFcmToken"] as? String).orEmpty
        self.isRead = (noticeDic["isRead"] as? Bool) ?? false
    }
    
    init(document: DocumentSnapshot) {
        let noticeDic = document.data()
        self.id = document.documentID
        self.createdAt = (noticeDic?["createdAt"] as? Timestamp ?? .init())
        self.recieverUserId = (noticeDic?["recieverUserId"] as? String).orEmpty
        self.recieverUserFcmToken = (noticeDic?["recieverUserFcmToken"] as? String).orEmpty
        self.isRead = (noticeDic?["isRead"] as? Bool) ?? false
    }
}
