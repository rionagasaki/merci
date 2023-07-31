//
//  Notice.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/07/21.
//
import Foundation
import FirebaseFirestore

class Notice {
    var chatID: String
    var message: String
    var createdAt: Timestamp
    var sendUserID: String
    var sendUserNickname: String
    var sendUserProfileImageURL: String
    var notificationUserTokens:[String]
    
    init(document: QueryDocumentSnapshot){
        self.chatID = document.documentID
        let chatDic = document.data()
        // TextかImageかのどちらかが入る。
        self.message = (chatDic["message"] as? String).orEmpty
        self.createdAt = ((chatDic["createdAt"] as? Timestamp)!)
        self.sendUserID = (chatDic["sendUserID"] as? String).orEmpty
        self.sendUserNickname = (chatDic["sendUserNickname"] as? String).orEmpty
        self.sendUserProfileImageURL = (chatDic["sendUserProfileImageURL"] as? String).orEmpty
        self.notificationUserTokens = (chatDic["notificationUserTokens"] as? [String]).orEmptyArray
    }
    init(document: DocumentSnapshot){
        self.chatID = document.documentID
        let chatDic = document.data()
        self.message = (chatDic?["message"] as? String).orEmpty
        self.createdAt = ((chatDic?["createdAt"] as? Timestamp)!)
        self.sendUserID = (chatDic?["sendUserID"] as? String).orEmpty
        self.sendUserNickname = (chatDic?["sendUserNickName"] as? String).orEmpty
        self.sendUserProfileImageURL = (chatDic?["sendUserProfileImageURL"] as? String).orEmpty
        self.notificationUserTokens = (chatDic?["notificationUserTokens"] as? [String]).orEmptyArray
    }
}


// User情報を管理するObservableObject
final class NoticeObservableModel: ObservableObject, Identifiable {
    var id = UUID()
    @Published var chatID: String = ""
    @Published var message: String = ""
    @Published var createdAt: String = ""
    @Published var sendUserID: String = ""
    @Published var sendUserNickname: String = ""
    @Published var sendUserProfileImageURL: String = ""
    @Published var notificationUserTokens:[String] = []
    
    init(chatID: String = "", message: String = "", createdAt: String = "", sendUserID:String = "", sendUserNickname: String = "", sendUserProfileImageURL: String = "", notificationUserTokens:[String] = []){
        self.chatID = chatID
        self.message = message
        self.createdAt = createdAt
        self.sendUserID = sendUserID
        self.sendUserNickname = sendUserNickname
        self.sendUserProfileImageURL = sendUserProfileImageURL
        self.notificationUserTokens = notificationUserTokens
    }
}

