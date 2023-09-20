//
//  Comment.swift
//  SNSTictok
//
//  Created by Rio Nagasaki on 2023/07/14.
//

import Foundation
import FirebaseFirestore

class Comment {
    var id: String
    var uid: String
    var nickname: String
    var profileImageURLString: String
    var mentionUserDic: [String: String]
    var message: String
    var createdAt: Timestamp
    
    
    init(document: QueryDocumentSnapshot){
        let commentDic = document.data()
        self.id = document.documentID
        self.uid = (commentDic["uid"] as? String).orEmpty
        self.nickname = (commentDic["nickname"] as? String).orEmpty
        self.profileImageURLString = (commentDic["profileImageUrlString"] as? String).orEmpty
        self.message = (commentDic["message"] as? String).orEmpty
        self.mentionUserDic = (commentDic["mentionUserDic"] as? [String: String]) ?? [:]
        self.createdAt = ((commentDic["createdAt"] as? Timestamp ?? .init()))
    }
    
    init(document: DocumentSnapshot){
        let commentDic = document.data()
        self.id = document.documentID
        self.uid = (commentDic?["uid"] as? String).orEmpty
        self.nickname = (commentDic?["nickname"] as? String).orEmpty
        self.profileImageURLString = (commentDic?["profileImageUrlString"] as? String).orEmpty
        self.message = (commentDic?["message"] as? String).orEmpty
        self.mentionUserDic = (commentDic?["mentionUserId"] as? [String: String]) ?? [:]
        self.createdAt = ((commentDic?["createdAt"] as? Timestamp ?? .init()))
    }
    
    func adaptCommentObservableModel() -> CommentObservableModel {
        return .init(
            id: self.id,
            uid: self.uid,
            nickname: self.nickname,
            profileImageUrlString: self.profileImageURLString,
            message: self.message,
            mentionUserDic: self.mentionUserDic,
            createdAt: DateFormat.customDateFormat(date: self.createdAt.dateValue())
        )
    }
}


// User情報を管理するObservableObject
final class CommentObservableModel: ObservableObject, Identifiable {
    @Published var id: String = ""
    @Published var uid: String = ""
    @Published var nickname: String = ""
    @Published var profileImageUrlString: String = ""
    @Published var message: String = ""
    @Published var mentionUserDic: [String: String] = [:]
    @Published var createdAt: String = ""
    
    init(
        id: String = "",
        uid: String = "",
        nickname: String = "",
        profileImageUrlString: String = "",
        message: String = "",
        mentionUserDic: [String: String] = [:],
        createdAt: String = ""
    ){
        self.id = id
        self.uid = uid
        self.nickname = nickname
        self.profileImageUrlString = profileImageUrlString
        self.message = message
        self.mentionUserDic = mentionUserDic
        self.createdAt = createdAt
    }
}


