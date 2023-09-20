//
//  CommentNotice.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/08/26.
//

import Foundation
import FirebaseFirestore

class CommentNotice: Notice {
    
    var recieverPostId: String
    var recieverPostText: String
    var triggerUserNickNameMapping: [String: String]
    var triggerUserProfileImageUrlStringMapping: [String: String]
    var lastTriggerUserUid: String
    var lastTriggerCommentText: String
    
    override init(document: QueryDocumentSnapshot) {
        let commentDic = document.data()
        self.recieverPostId = (commentDic["recieverPostId"] as? String).orEmpty
        self.recieverPostText = (commentDic["recieverPostText"] as? String).orEmpty
        self.triggerUserNickNameMapping = (commentDic["triggerUserNickNameMapping"] as? [String: String]) ?? [:]
        self.triggerUserProfileImageUrlStringMapping = (commentDic["triggerUserProfileImageUrlStringMapping"] as? [String: String]) ?? [:]
        self.lastTriggerUserUid = (commentDic["lastTriggerUserUid"] as? String).orEmpty
        self.lastTriggerCommentText = (commentDic["lastTriggerCommentText"] as? String).orEmpty
        super.init(document: document)
    }
    
    override init(document: DocumentSnapshot) {
        let commentDic = document.data()
        self.recieverPostId = (commentDic?["recieverPostId"] as? String).orEmpty
        self.recieverPostText = (commentDic?["recieverPostText"] as? String).orEmpty
        self.triggerUserNickNameMapping = (commentDic?["triggerUserNickNameMapping"] as? [String: String]) ?? [:]
        self.triggerUserProfileImageUrlStringMapping = (commentDic?["triggerUserProfileImageUrlStringMapping"] as? [String: String]) ?? [:]
        self.lastTriggerUserUid = (commentDic?["lastTriggerUserUid"] as? String).orEmpty
        self.lastTriggerCommentText = (commentDic?["lastTriggerCommentText"] as? String).orEmpty
        super.init(document: document)
    }
    
    func adaptNoticeObservableModel() -> CommentNoticeObservableModel {
            return .init(
                id: self.id,
                createdAt: DateFormat.customDateFormat(date: self.createdAt.dateValue()),
                recieverUserId: self.recieverUserId,
                recieverPostId: self.recieverPostId,
                recieverPostText: self.recieverPostText,
                recieverUserFcmToken: self.recieverUserFcmToken,
                triggerUserNickNameMapping: self.triggerUserNickNameMapping,
                triggerUserProfileImageUrlStringMapping: self.triggerUserProfileImageUrlStringMapping,
                lastTriggerUserUid: self.lastTriggerUserUid,
                lastTriggerCommentText: self.lastTriggerCommentText,
                isRead: self.isRead
            )
        }
}


final class CommentNoticeObservableModel: ObservableObject, Identifiable {
    @Published var id: String = ""
    @Published var createdAt: String = ""
    @Published var recieverUserId: String = ""
    @Published var recieverPostId: String = ""
    @Published var recieverPostText: String = ""
    @Published var recieverUserFcmToken: String = ""
    @Published var triggerUserNickNameMapping: [String: String] = [:]
    @Published var triggerUserProfileImageUrlStringMapping: [String: String] = [:]
    @Published var lastTriggerUserUid: String = ""
    @Published var lastTriggerCommentText: String = ""
    @Published var isRead: Bool = false
    
    init(
        id: String = "",
        createdAt: String = "",
        recieverUserId: String = "",
        recieverPostId: String = "",
        recieverPostText: String = "",
        recieverUserFcmToken: String = "",
        triggerUserNickNameMapping: [String: String] = [:],
        triggerUserProfileImageUrlStringMapping: [String: String] = [:],
        lastTriggerUserUid: String = "",
        lastTriggerCommentText: String = "",
        isRead: Bool = false
    ){
        self.id = id
        self.createdAt = createdAt
        self.recieverUserId = recieverUserId
        self.recieverPostId = recieverPostId
        self.recieverPostText = recieverPostText
        self.recieverUserFcmToken = recieverUserFcmToken
        self.triggerUserNickNameMapping = triggerUserNickNameMapping
        self.triggerUserProfileImageUrlStringMapping = triggerUserProfileImageUrlStringMapping
        self.lastTriggerUserUid = lastTriggerUserUid
        self.lastTriggerCommentText = lastTriggerCommentText
        self.isRead = isRead
    }
}
