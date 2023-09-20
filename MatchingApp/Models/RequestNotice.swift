//
//  RequestNotice.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/08/26.
//

import Foundation
import FirebaseFirestore

class RequestNotice: Notice {
    var type: String
    var triggerUserUid: String
    var triggerUserNickName: String
    var triggerUserProfileImageUrlString: String
    
    override init(document: QueryDocumentSnapshot) {
        let requestDic = document.data()
        self.type = (requestDic["type"] as? String).orEmpty
        self.triggerUserUid = (requestDic["triggerUserUid"] as? String).orEmpty
        self.triggerUserNickName = (requestDic["triggerUserNickName"] as? String).orEmpty
        self.triggerUserProfileImageUrlString = (requestDic["triggerUserProfileImageUrlString"] as? String).orEmpty
        super.init(document: document)
    }
    
    override init(document: DocumentSnapshot) {
        let requestDic = document.data()
        self.type = (requestDic?["type"] as? String).orEmpty
        self.triggerUserUid = (requestDic?["triggerUserUid"] as? String).orEmpty
        self.triggerUserNickName = (requestDic?["triggerUserNickName"] as? String).orEmpty
        self.triggerUserProfileImageUrlString = (requestDic?["triggerUserProfileImageUrlString"] as? String).orEmpty
        super.init(document: document)
    }
    
    func adaptNoticeObservableModel() -> RequestNoticeObservableModel {
            return .init(
                id: self.id,
                type: self.type,
                createdAt: DateFormat.customDateFormat(date: self.createdAt.dateValue()),
                isRead: self.isRead,
                recieverUserId: self.recieverUserId,
                recieverUserFcmToken: self.recieverUserFcmToken,
                triggerUserUid: self.triggerUserUid,
                triggerUserNickName: self.triggerUserNickName,
                triggerUserProfileImageUrlString: self.triggerUserProfileImageUrlString
            )
        }
}

final class RequestNoticeObservableModel: ObservableObject, Identifiable {
    
    @Published var id: String = ""
    @Published var type: String = ""
    @Published var createdAt: String = ""
    @Published var isRead: Bool = false
    @Published var recieverUserId: String = ""
    @Published var recieverUserFcmToken: String = ""
    @Published var triggerUserUid: String = ""
    @Published var triggerUserNickName: String = ""
    @Published var triggerUserProfileImageUrlString: String = ""
    
    init(
        id: String = "",
        type: String = "",
        createdAt: String = "",
        isRead: Bool = false,
        recieverUserId: String = "",
        recieverUserFcmToken: String = "",
        triggerUserUid: String = "",
        triggerUserNickName: String = "",
        triggerUserProfileImageUrlString: String = ""
    ){
        self.id = id
        self.type = type
        self.createdAt = createdAt
        self.isRead = isRead
        self.recieverUserId = recieverUserId
        self.recieverUserFcmToken = recieverUserFcmToken
        self.triggerUserUid = triggerUserUid
        self.triggerUserNickName = triggerUserNickName
        self.triggerUserProfileImageUrlString = triggerUserProfileImageUrlString
    }
}
