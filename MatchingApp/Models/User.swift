//
//  User.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/22.
//

import Foundation
import FirebaseFirestore

class User {
    // 基本情報
    var id: String
    var fcmToken: String
    var activeCallUid: String
    var nickname: String
    var email: String
    var gender: String
    var profileImageURL: String
    var coins: Int
    var onboarding: Bool
    var isCallingChannelId: String
    
    // プロフィール
    var activityRegion: String
    var birthDate: String
    var hobbies: [String]
    var introduction: String
    
    var friendRequestUids: [String]
    var friendRequestedUids: [String]
    var friendUids: [String]
    var friendEarliestPostTimestampMapping: [String: Timestamp]
    
    var likesPosts: [String]
    var replyPosts: [String]
    
    var notificationMapping: [String: String]
    var chatmateMapping: [String: String]
    var chatLastMessageMapping: [String: String]
    var chatLastTimestampMapping: [String: Timestamp]
    var unreadMessageCount: [String: Int]
    
    var tab_item_notice: [String]

    init(document: QueryDocumentSnapshot){
        let userDic = document.data()
        self.id = document.documentID
        self.fcmToken = (userDic["fcmToken"] as? String).orEmpty
        self.activeCallUid = (userDic["activeCallUid"] as? String).orEmpty
        self.nickname = (userDic["nickname"] as? String).orEmpty
        self.email = (userDic["email"] as? String).orEmpty
        self.gender = (userDic["gender"] as? String).orEmpty
        self.profileImageURL = (userDic["profileImageURL"] as? String).orEmpty
        self.coins = (userDic["coins"] as? Int).orEmptyNum
        self.onboarding = userDic["onboarding"] as? Bool ?? false
        self.isCallingChannelId = (userDic["isCallingChannelId"] as? String).orEmpty
        
        self.activityRegion = (userDic["activityRegion"] as? String).orEmpty
        self.birthDate = (userDic["birthDate"] as? String).orEmpty
        self.hobbies = (userDic["hobbies"] as? [String]).orEmptyArray
        self.introduction = (userDic["introduction"] as? String).orEmpty
    
        self.friendRequestUids = (userDic["friendRequestUids"] as? [String]).orEmptyArray
        self.friendRequestedUids = (userDic["friendRequestedUids"] as? [String]).orEmptyArray
        self.friendUids = (userDic["friendUids"] as? [String]).orEmptyArray
        self.friendEarliestPostTimestampMapping = (userDic["friendEarliestPostTimestampMapping"] as? [String: Timestamp]) ?? [:]
        
        self.likesPosts = (userDic["likesPosts"] as? [String]).orEmptyArray
        self.replyPosts = (userDic["replyPosts"] as? [String]).orEmptyArray
        
        self.notificationMapping = (userDic["notificationMapping"] as? [String: String]) ?? [:]
        self.chatmateMapping = (userDic["chatmateMapping"] as? [String: String]) ?? [:]
        self.chatLastMessageMapping = (userDic["chatLastMessageMapping"] as? [String: String]) ?? [:]
        self.chatLastTimestampMapping = (userDic["chatLastTimestampMapping"] as? [String: Timestamp]) ?? [:]
        self.unreadMessageCount = (userDic["unreadMessageCount"] as? [String: Int] ?? [:])
        
        self.tab_item_notice = (userDic["tab_item_notice"] as? [String]).orEmptyArray
    }
    
    init(document: DocumentSnapshot){
        let userDic = document.data()
        self.id = document.documentID
        self.fcmToken = (userDic?["fcmToken"] as? String).orEmpty
        self.activeCallUid = (userDic?["activeCallUid"] as? String).orEmpty
        self.nickname = (userDic?["nickname"] as? String).orEmpty
        self.email = (userDic?["email"] as? String).orEmpty
        self.profileImageURL = (userDic?["profileImageURL"] as? String).orEmpty
        self.coins = (userDic?["coins"] as? Int).orEmptyNum
        self.onboarding = userDic?["onboarding"] as? Bool ?? false
        self.isCallingChannelId = (userDic?["isCallingChannelId"] as? String).orEmpty
        
        self.activityRegion = (userDic?["activityRegion"] as? String).orEmpty
        self.birthDate = (userDic?["birthDate"] as? String).orEmpty
        self.gender = (userDic?["gender"] as? String).orEmpty
        self.hobbies = (userDic?["hobbies"] as? [String]).orEmptyArray
        self.introduction = (userDic?["introduction"] as? String).orEmpty

        self.friendRequestUids = (userDic?["friendRequestUids"] as? [String]).orEmptyArray
        self.friendRequestedUids = (userDic?["friendRequestedUids"] as? [String]).orEmptyArray
        self.friendUids = (userDic?["friendUids"] as? [String]).orEmptyArray
        self.friendEarliestPostTimestampMapping = (userDic?["friendEarliestPostTimestampMapping"] as? [String: Timestamp]) ?? [:]
        
        self.likesPosts = (userDic?["likesPosts"] as? [String]).orEmptyArray
        self.replyPosts = (userDic?["replyPosts"] as? [String]).orEmptyArray
        
        self.notificationMapping = (userDic?["notificationMapping"] as? [String: String]) ?? [:]
        self.chatmateMapping = (userDic?["chatmateMapping"] as? [String: String]) ?? [:]
        self.chatLastMessageMapping = (userDic?["chatLastMessageMapping"] as? [String: String]) ?? [:]
        self.chatLastTimestampMapping = (userDic?["chatLastTimestampMapping"] as? [String: Timestamp]) ?? [:]
        self.unreadMessageCount = (userDic?["unreadMessageCount"] as? [String: Int] ?? [:])
        
        self.tab_item_notice = (userDic?["tab_item_notice"] as? [String]).orEmptyArray
    }
    
    func adaptUserObservableModel() -> UserModel {
        return .init(
            uid: self.id,
            fcmToken: self.fcmToken,
            activeCallUid: self.activeCallUid,
            nickname: self.nickname,
            email: self.email,
            gender: self.gender,
            profileImageURLString: self.profileImageURL,
            coins: self.coins,
            onboarding: self.onboarding,
            isCallingChannelId: self.isCallingChannelId,
            activeRegion: self.activityRegion,
            birthDate: self.birthDate,
            hobbies: self.hobbies,
            introduction: self.introduction,
            friendRequestUids: self.friendRequestUids,
            friendRequestedUids: self.friendRequestedUids,
            friendUids: self.friendUids,
            friendEarliestPostTimestampMapping: self.friendEarliestPostTimestampMapping,
            likesPosts: self.likesPosts,
            replyPosts: self.replyPosts,
            notificationMapping: self.notificationMapping,
            chatmateMapping: self.chatmateMapping,
            chatLastMessageMapping: self.chatLastMessageMapping,
            chatLastMessageTimestamp: self.chatLastTimestampMapping,
            chatLastMessageTimestampString: ConvertMapping.convertMapping(self.chatLastTimestampMapping),
            unreadMessageCount: self.unreadMessageCount,
            tab_item_notice: ConvertMapping.convertMappingToBool(self.unreadMessageCount, notice: self.tab_item_notice)
        )
    }
}

struct UserModel {
    var uid: String = ""
    var fcmToken: String = ""
    var activeCallUid: String = ""
    var nickname: String = ""
    var email: String = ""
    var gender: String = ""
    var profileImageURLString: String = ""
    var coins: Int = 0
    var onboarding: Bool = false
    var isCallingChannelId: String = ""
    var activeRegion: String = ""
    var birthDate: String = ""
    var hobbies: [String] = []
    var introduction:String = ""
    
    var friendRequestUids: [String] = []
    var friendRequestedUids: [String] = []
    var friendUids: [String] = []
    var friendEarliestPostTimestampMapping: [String: Timestamp] = [:]
    
    var likesPosts: [String] = []
    var replyPosts: [String] = []
    
    var notificationMapping: [String: String] = [:]
    var chatmateMapping: [String: String] = [:]
    var chatLastMessageMapping: [String: String] = [:]
    var chatLastMessageTimestamp: [String: Timestamp] = [:]
    var chatLastMessageTimestampString: [String: String] = [:]
    var unreadMessageCount:[String: Int] = [:]
    
    var tab_item_notice: [String] = []
}

// User情報を管理するObservableObject
final class UserObservableModel: ObservableObject, Identifiable {
    @Published var user: UserModel = .init()
    
    init(userModel: UserModel){
        self.user = userModel
    }
    let genders = ["男性", "女性", "未回答"]
    let tokyo23Wards = ["千代田区", "中央区", "港区", "新宿区", "文京区", "台東区", "墨田区", "江東区", "品川区", "目黒区", "大田区", "世田谷区", "渋谷区", "中野区", "杉並区", "豊島区", "北区", "荒川区", "板橋区", "練馬区", "足立区", "葛飾区", "江戸川区"]

    func initial(){
        self.user = .init()
    }
}
