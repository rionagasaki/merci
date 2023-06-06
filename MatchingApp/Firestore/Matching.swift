//
//  Matching.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/06/01.
//

import Foundation
import FirebaseFirestore

class Matching {
    var id = UUID()
    var lessonId: String
    var chatroomId: String
    var mentorUid: String
    var studentUid: String
    var lastMessageText: String
    var lastMessageDate: String
    
    init(document: QueryDocumentSnapshot){
        self.chatroomId = document.documentID
        let messageDic = document.data()
        self.lessonId = (messageDic["lessonId"] as? String).orEmpty
        self.mentorUid = (messageDic["mentorUid"] as? String).orEmpty
        self.studentUid = (messageDic["studentUid"] as? String).orEmpty
        self.lastMessageText = (messageDic["lastMessageText"] as? String).orEmpty
        self.lastMessageDate = (messageDic["lastMessageDate"] as? String).orEmpty
    }
    
    init(document: DocumentSnapshot){
        self.chatroomId = document.documentID
        let messageDic = document.data()
        self.lessonId = (messageDic?["lessonId"] as? String).orEmpty
        self.mentorUid = (messageDic?["mentorUid"] as? String).orEmpty
        self.studentUid = (messageDic?["studentUid"] as? String).orEmpty
        self.lastMessageText = (messageDic?["lastMessageText"] as? String).orEmpty
        self.lastMessageDate = (messageDic?["lastMessageDate"] as? String).orEmpty
    }
}

final class MatchingObservableModel: ObservableObject {
    @Published var chatID: String = ""
    @Published var messageText: String = ""
    @Published var messageType: String = ""
    @Published var messageDate: String = ""
    @Published var senderUid: String = ""
    
    init(chatID: String = "", messageText: String = "", messageType: String = "", messageDate: String = "", senderUid:String = ""){
        self.chatID = chatID
        self.messageText = messageText
        self.messageType = messageType
        self.messageDate = messageDate
        self.senderUid = senderUid
    }
}
