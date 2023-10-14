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
    var type: String
    var message: String
    var createdAt: Timestamp
    var fromUserUid: String
    var fromUserNickname: String
    var fromUserProfileImageUrl: String
    var concernID: String
    var concernKind: String
    var concernText: String
    var concernKindImageName: String
    var toUserToken: String
    
    init(document: QueryDocumentSnapshot){
        self.chatId = document.documentID
        let chatDic = document.data()
        self.type = (chatDic["type"] as? String).orEmpty
        self.message = (chatDic["message"] as? String).orEmpty
        self.createdAt = ((chatDic["createdAt"] as? Timestamp)!)
        self.fromUserUid = (chatDic["fromUserUid"] as? String).orEmpty
        self.fromUserNickname = (chatDic["fromUserNickname"] as? String).orEmpty
        self.fromUserProfileImageUrl = (chatDic["fromUserProfileImageUrl"] as? String).orEmpty
        self.concernID = (chatDic["concernID"] as? String).orEmpty
        self.concernKind = (chatDic["concernKind"] as? String).orEmpty
        self.concernText = (chatDic["concernText"] as? String).orEmpty
        self.concernKindImageName = (chatDic["concernKindImageName"] as? String).orEmpty
        self.toUserToken = (chatDic["toUserToken"] as? String).orEmpty
    }
    
    init(document: DocumentSnapshot){
        self.chatId = document.documentID
        let chatDic = document.data()
        self.type = (chatDic?["type"] as? String).orEmpty
        self.message = (chatDic?["message"] as? String).orEmpty
        self.createdAt = ((chatDic?["createdAt"] as? Timestamp)!)
        self.fromUserUid = (chatDic?["fromUserUid"] as? String).orEmpty
        self.fromUserNickname = (chatDic?["fromUserNickname"] as? String).orEmpty
        self.fromUserProfileImageUrl = (chatDic?["fromUserProfileImageUrl"] as? String).orEmpty
        self.concernID = (chatDic?["concernID"] as? String).orEmpty
        self.concernKind = (chatDic?["concernKind"] as? String).orEmpty
        self.concernText = (chatDic?["concernText"] as? String).orEmpty
        self.concernKindImageName = (chatDic?["concernKindImageName"] as? String).orEmpty
        self.toUserToken = (chatDic?["toUserToken"] as? String).orEmpty
    }
    
    func adaptionChatData() -> ChatObservableModel {
        return .init(
            chatId: self.chatId,
            type: self.type,
            message: self.message,
            createdAtDateValue: self.createdAt.dateValue(),
            createdAt: DateFormat.timeFormat(date: self.createdAt.dateValue()),
            fromUserUid: self.fromUserUid,
            fromUserNickname: self.fromUserNickname,
            fromUserProfileImageUrl: self.fromUserProfileImageUrl,
            concernID: self.concernID,
            concernKind: self.concernKind,
            concernText: self.concernText,
            concernKindImageName: self.concernKindImageName,
            toUserToken: self.toUserToken
        )
    }
}

final class ChatObservableModel: ObservableObject, Identifiable, Equatable {
    static func == (lhs: ChatObservableModel, rhs: ChatObservableModel) -> Bool {
        return true
    }
    
    var id = UUID()
    @Published var chatId: String = ""
    @Published var type: String = ""
    @Published var message: String = ""
    @Published var createdAtDateValue: Date = .init()
    @Published var createdAt: String = ""
    @Published var fromUserUid: String = ""
    @Published var fromUserNickname: String = ""
    @Published var fromUserProfileImageUrl: String = ""
    @Published var concernID: String
    @Published var concernKind: String = ""
    @Published var concernText: String = ""
    @Published var concernKindImageName: String = ""
    @Published var toUserToken: String = ""
    
    init(
        chatId: String = "",
        type: String = "",
        message: String = "",
        createdAtDateValue: Date = .init(),
        createdAt: String = "",
        fromUserUid:String = "",
        fromUserNickname: String = "",
        fromUserProfileImageUrl: String = "",
        concernID: String = "",
        concernKind: String = "",
        concernText: String = "",
        concernKindImageName: String = "",
        toUserToken: String = ""
    ){
        self.chatId = chatId
        self.type = type
        self.message = message
        self.createdAtDateValue = createdAtDateValue
        self.createdAt = createdAt
        self.fromUserUid = fromUserUid
        self.fromUserNickname = fromUserNickname
        self.fromUserProfileImageUrl = fromUserProfileImageUrl
        self.concernID = concernID
        self.concernText = concernText
        self.concernKind = concernKind
        self.concernKindImageName = concernKindImageName
        self.toUserToken = toUserToken
    }
}
