//
//  Chat.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/06/01.
//

import Foundation
import FirebaseFirestore

class ChatRoomData {
    var chatmate: [String]
    var channelId: String
    var callingMate: [String]
    
    init(document: QueryDocumentSnapshot){
        let chatDic = document.data()
        self.chatmate = (chatDic["chatmate"] as? [String]).orEmptyArray
        self.channelId = (chatDic["channelId"] as? String).orEmpty
        self.callingMate = (chatDic["callingMate"] as? [String]).orEmptyArray
    }
    
    init(document: DocumentSnapshot){
        let chatDic = document.data()
        self.chatmate = (chatDic?["chatmate"] as? [String]).orEmptyArray
        self.channelId = (chatDic?["channelId"] as? String).orEmpty
        self.callingMate = (chatDic?["callingMate"] as? [String]).orEmptyArray
    }
}

class Chat {
    var chatId: String
    var message: String
    var createdAt: Timestamp
    var fromUserUid: String
    var fromUserNickname: String
    var fromUserProfileImageUrl: String
    var toUserToken: String
    
    init(document: QueryDocumentSnapshot){
        self.chatId = document.documentID
        let chatDic = document.data()
        self.message = (chatDic["message"] as? String).orEmpty
        self.createdAt = ((chatDic["createdAt"] as? Timestamp)!)
        self.fromUserUid = (chatDic["fromUserUid"] as? String).orEmpty
        self.fromUserNickname = (chatDic["fromUserNickname"] as? String).orEmpty
        self.fromUserProfileImageUrl = (chatDic["fromUserProfileImageUrl"] as? String).orEmpty
        self.toUserToken = (chatDic["toUserToken"] as? String).orEmpty
    }
    
    init(document: DocumentSnapshot){
        self.chatId = document.documentID
        let chatDic = document.data()
        self.message = (chatDic?["message"] as? String).orEmpty
        self.createdAt = ((chatDic?["createdAt"] as? Timestamp)!)
        self.fromUserUid = (chatDic?["fromUserUid"] as? String).orEmpty
        self.fromUserNickname = (chatDic?["fromUserNickname"] as? String).orEmpty
        self.fromUserProfileImageUrl = (chatDic?["fromUserProfileImageUrl"] as? String).orEmpty
        self.toUserToken = (chatDic?["toUserToken"] as? String).orEmpty
    }
}

final class ChatObservableModel: ObservableObject, Identifiable, Equatable {
    static func == (lhs: ChatObservableModel, rhs: ChatObservableModel) -> Bool {
        return true
    }
    
    var id = UUID()
    @Published var chatId: String = ""
    @Published var message: String = ""
    @Published var createdAt: String = ""
    @Published var fromUserUid: String = ""
    @Published var fromUserNickname: String = ""
    @Published var fromUserProfileImageUrl: String = ""
    @Published var toUserToken: String = ""
    
    init(
        chatId: String = "",
        message: String = "",
        createdAt: String = "",
        fromUserUid:String = "",
        fromUserNickname: String = "",
        fromUserProfileImageUrl: String = "",
        toUserToken: String = ""
    ){
        self.chatId = chatId
        self.message = message
        self.createdAt = createdAt
        self.fromUserUid = fromUserUid
        self.fromUserNickname = fromUserNickname
        self.fromUserProfileImageUrl = fromUserProfileImageUrl
        self.toUserToken = toUserToken
    }
}
