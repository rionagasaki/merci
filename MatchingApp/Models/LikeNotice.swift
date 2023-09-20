//
//  LikeNotice.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/08/26.
//

import Foundation
import FirebaseFirestore

class LikeNotice: Notice {
    var recieverPostId: String
    var recieverPostText: String
    var triggerUserNickNameMapping: [String: String]
    var triggerUserProfileImageUrlStringMapping: [String: String]
    var lastTriggerUserUid: String
    
    override init(document: QueryDocumentSnapshot){
        let likeDic = document.data()
        self.recieverPostId = (likeDic["recieverPostId"] as? String).orEmpty
        self.recieverPostText = (likeDic["recieverPostText"] as? String).orEmpty
        self.triggerUserNickNameMapping = (likeDic["triggerUserNickNameMapping"] as? [String: String]) ?? [:]
        self.triggerUserProfileImageUrlStringMapping = (likeDic["triggerUserProfileImageUrlStringMapping"] as? [String: String]) ?? [:]
        self.lastTriggerUserUid = (likeDic["lastTriggerUserUid"] as? String).orEmpty
        super.init(document: document)
    }
    
    override init(document: DocumentSnapshot){
        let likeDic = document.data()
        self.recieverPostId = (likeDic?["recieverPostId"] as? String).orEmpty
        self.recieverPostText = (likeDic?["recieverPostText"] as? String).orEmpty
        self.triggerUserNickNameMapping = (likeDic?["triggerUserNickNameMapping"] as? [String: String]) ?? [:]
        self.triggerUserProfileImageUrlStringMapping = (likeDic?["triggerUserProfileImageUrlStringMapping"] as? [String: String]) ?? [:]
        self.lastTriggerUserUid = (likeDic?["lastTriggerUserUid"] as? String).orEmpty
        super.init(document: document)
    }
    
    func adaptNoticeObservableModel() -> LikeNoticeObservableModel {
            return .init(
                id: self.id,
                createdAt: DateFormat.customDateFormat(date: self.createdAt.dateValue()),
                recieverUserId: self.recieverUserId,
                recieverPostId: self.recieverPostId,
                recieverPostText: self.recieverPostText,
                triggerUserNickNameMapping: self.triggerUserNickNameMapping,
                triggerUserProfileImageUrlStringMapping: self.triggerUserProfileImageUrlStringMapping,
                lastTriggerUserUid: self.lastTriggerUserUid,
                isRead: self.isRead
            )
        }
}

final class LikeNoticeObservableModel: ObservableObject, Identifiable {
    @Published var id: String = ""
    @Published var createdAt: String = ""
    @Published var recieverUserId: String = ""
    @Published var recieverPostId: String = ""
    @Published var recieverPostText: String = ""
    @Published var triggerUserNickNameMapping: [String: String] = [:]
    @Published var triggerUserProfileImageUrlStringMapping: [String: String] = [:]
    @Published var lastTriggerUserUid: String = ""
    @Published var isRead: Bool = false
    
    init(
        id: String = "",
        createdAt: String = "",
        recieverUserId: String = "",
        recieverPostId: String = "",
        recieverPostText: String = "",
        triggerUserNickNameMapping: [String: String] = [:],
        triggerUserProfileImageUrlStringMapping: [String: String] = [:],
        lastTriggerUserUid: String = "",
        isRead: Bool = false
    ){
        self.id = id
        self.createdAt = createdAt
        self.recieverUserId = recieverUserId
        self.recieverPostId = recieverPostId
        self.recieverPostText = recieverPostText
        self.triggerUserNickNameMapping = triggerUserNickNameMapping
        self.triggerUserProfileImageUrlStringMapping = triggerUserProfileImageUrlStringMapping
        self.lastTriggerUserUid = lastTriggerUserUid
        self.isRead = isRead
    }
}
