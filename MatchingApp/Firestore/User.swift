//
//  User.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/22.
//

import Foundation
import FirebaseFirestore

class User {
    var id: String
    var fcmToken: String
    var coins: Int
    var nickname: String
    var email: String
    var gender: String
    var birthDate: String
    var introduction: String
    var profileImageURL: String
    var subProfileImageURLs: [String]
    var activityRegion: String
    var birthPlace: String
    var educationalBackground: String
    var work: String
    var height: String
    var weight: String
    var bloodType: String
    var liquor: String
    var cigarettes: String
    var purpose: String
    var datingExpenses: String
    var requestUids: [String]
    var requestedUids: [String]
    var pairRequestUid: String
    var pairRequestedUids: [String]
    var friendUids:[String]
    var hobbies: [String]
    var pairUid: String
    var pairID: String
    var pairList: [String: String]
    var chatUnreadNum: [String: Int]
    
    init(document: QueryDocumentSnapshot){
        let userDic = document.data()
        self.id = document.documentID
        self.fcmToken = (userDic["fcmToken"] as? String).orEmpty
        self.nickname = (userDic["nickname"] as? String).orEmpty
        self.coins = (userDic["coins"] as? Int).orEmptyNum
        self.email = (userDic["email"] as? String).orEmpty
        self.profileImageURL = (userDic["profileImageURL"] as? String).orEmpty
        self.subProfileImageURLs = (userDic["subProfileImageURLs"] as? [String]).orEmptyArray
        self.birthDate = (userDic["birthDate"] as? String).orEmpty
        self.gender = (userDic["gender"] as? String).orEmpty
        self.activityRegion = (userDic["activityRegion"] as? String).orEmpty
        self.birthPlace = (userDic["birthPlace"] as? String).orEmpty
        self.educationalBackground = (userDic["educationalBackground"] as? String).orEmpty
        self.work = (userDic["work"] as? String).orEmpty
        self.height = (userDic["height"] as? String).orEmpty
        self.weight = (userDic["weight"] as? String).orEmpty
        self.bloodType = (userDic["bloodType"] as? String).orEmpty
        self.liquor = (userDic["liquor"] as? String).orEmpty
        self.cigarettes = (userDic["cigarettes"] as? String).orEmpty
        self.purpose = (userDic["purpose"] as? String).orEmpty
        self.datingExpenses = (userDic["datingExpenses"] as? String).orEmpty
        self.friendUids = (userDic["friendUids"] as? [String]).orEmptyArray
        self.introduction = (userDic["introduction"] as? String).orEmpty
        self.requestUids = (userDic["requestUid"] as? [String]).orEmptyArray
        self.requestedUids = (userDic["requestedUid"] as? [String]).orEmptyArray
        self.pairRequestUid = (userDic["pairRequestUid"] as? String).orEmpty
        self.pairRequestedUids = (userDic["pairRequestedUids"] as? [String]).orEmptyArray
        self.hobbies = (userDic["hobbies"] as? [String]).orEmptyArray
        self.pairUid = (userDic["pairUid"] as? String).orEmpty
        self.pairID = (userDic["pairID"] as? String).orEmpty
        self.pairList = (userDic["pairList"] as? [String: String] ?? [:])
        self.chatUnreadNum = (userDic["chatUnreadNum"] as? [String: Int] ?? [:])
    }
    
    init(document: DocumentSnapshot){
        let userDic = document.data()
        self.id = document.documentID
        self.fcmToken = (userDic?["fcmToken"] as? String).orEmpty
        self.nickname = (userDic?["nickname"] as? String).orEmpty
        self.coins = (userDic?["coins"] as? Int).orEmptyNum
        self.email = (userDic?["email"] as? String).orEmpty
        self.profileImageURL = (userDic?["profileImageURL"] as? String).orEmpty
        self.subProfileImageURLs = (userDic?["subProfileImageURLs"] as? [String]).orEmptyArray
        self.birthDate = (userDic?["birthDate"] as? String).orEmpty
        self.gender = (userDic?["gender"] as? String).orEmpty
        self.activityRegion = (userDic?["activityRegion"] as? String).orEmpty
        self.birthPlace = (userDic?["birthPlace"] as? String).orEmpty
        self.educationalBackground = (userDic?["educationalBackground"] as? String).orEmpty
        self.work = (userDic?["work"] as? String).orEmpty
        self.height = (userDic?["height"] as? String).orEmpty
        self.weight = (userDic?["weight"] as? String).orEmpty
        self.bloodType = (userDic?["bloodType"] as? String).orEmpty
        self.liquor = (userDic?["liquor"] as? String).orEmpty
        self.cigarettes = (userDic?["cigarettes"] as? String).orEmpty
        self.purpose = (userDic?["purpose"] as? String).orEmpty
        self.datingExpenses = (userDic?["datingExpenses"] as? String).orEmpty
        self.friendUids = (userDic?["friendUids"] as? [String]).orEmptyArray
        self.introduction = (userDic?["introduction"] as? String).orEmpty
        self.requestUids = (userDic?["requestUid"] as? [String]).orEmptyArray
        self.requestedUids = (userDic?["requestedUid"] as? [String]).orEmptyArray
        self.pairRequestUid = (userDic?["pairRequestUid"] as? String).orEmpty
        self.pairRequestedUids = (userDic?["pairRequestedUids"] as? [String]).orEmptyArray
        self.hobbies = (userDic?["hobbies"] as? [String]).orEmptyArray
        self.pairUid = (userDic?["pairUid"] as? String).orEmpty
        self.pairID = (userDic?["pairID"] as? String).orEmpty
        self.pairList = (userDic?["pairList"] as? [String: String] ?? [:])
        self.chatUnreadNum = (userDic?["chatUnreadNum"] as? [String: Int] ?? [:])
    }
    
    func adaptUserObservableModel() -> UserObservableModel {
        return .init(
            uid: self.id,
            nickname: self.nickname,
            coins: self.coins,
            email: self.email,
            gender: self.gender,
            activeRegion: self.activityRegion,
            birthPlace: self.birthPlace,
            educationalBackground: self.educationalBackground,
            work: self.work,
            height: self.height,
            weight: self.weight,
            bloodType: self.bloodType,
            liquor: self.liquor,
            cigarettes: self.cigarettes,
            purpose: self.purpose,
            datingExpenses: self.datingExpenses,
            friendUids: self.friendUids,
            introduction: self.introduction,
            birthDate: self.birthDate,
            profileImageURL: self.profileImageURL,
            subProfileImageURL: self.subProfileImageURLs,
            hobbies: self.hobbies,
            requestUids: self.requestUids,
            requestedUids: self.requestedUids,
            pairUid: self.pairUid,
            pairID: self.pairID,
            pairList: self.pairList,
            chatUnreadNum: self.chatUnreadNum
        )
    }
}


// User情報を管理するObservableObject
final class UserObservableModel: ObservableObject, Identifiable {
    
    @Published var uid: String = ""
    @Published var fcmToken: String = ""
    @Published var nickname: String = ""
    @Published var coins: Int = 0
    @Published var email: String = ""
    @Published var gender: String = ""
    @Published var activeRegion: String = ""
    @Published var birthPlace: String = ""
    @Published var educationalBackground: String = ""
    @Published var work: String = ""
    @Published var height: String = ""
    @Published var weight: String = ""
    @Published var bloodType: String = ""
    @Published var liquor: String = ""
    @Published var cigarettes: String = ""
    @Published var purpose: String = ""
    @Published var datingExpenses: String = ""
    @Published var friendUids: [String] = []
    @Published var introduction:String = ""
    @Published var birthDate: String = ""
    @Published var profileImageURL: String = ""
    @Published var subProfileImageURL: [String] = []
    @Published var hobbies: [String] = []
    @Published var requestUids: [String] = []
    @Published var requestedUids:[String] = []
    @Published var pairRequestUid: String = ""
    @Published var pairRequestedUids: [String] = []
    @Published var pairUid: String = ""
    @Published var pairID: String = ""
    @Published var pairList: [String:String] = [:]
    @Published var chatUnreadNum:[String: Int] = [:]
    let genders = ["🙋‍♂️男性", "💁‍♀️女性"]
    let tokyo23Wards = ["千代田区", "中央区", "港区", "新宿区", "文京区", "台東区", "墨田区", "江東区", "品川区", "目黒区", "大田区", "世田谷区", "渋谷区", "中野区", "杉並区", "豊島区", "北区", "荒川区", "板橋区", "練馬区", "足立区", "葛飾区", "江戸川区"]
    
    init(
        uid:String = "",
        fcmToken: String = "",
        nickname:String = "",
        coins: Int = 0,
        email:String = "",
        gender:String = "",
        activeRegion:String = "",
        birthPlace: String = "",
        educationalBackground: String = "",
        work: String = "",
        height: String = "",
        weight: String = "",
        bloodType: String = "",
        liquor: String = "",
        cigarettes: String = "",
        purpose: String = "",
        datingExpenses: String = "",
        friendUids: [String] = [],
        introduction:String = "",
        birthDate:String = "",
        profileImageURL:String = "",
        subProfileImageURL:[String] = [],
        hobbies:[String] = [],
        requestUids:[String] = [],
        requestedUids:[String] = [],
        pairRequestUids:String = "",
        pairRequestedUids: [String] = [],
        pairUid:String = "",
        pairID:String = "",
        pairList: [String: String] = [:],
        chatUnreadNum:[String: Int] = [:]
    ){
        self.uid = uid
        self.fcmToken = fcmToken
        self.nickname = nickname
        self.coins = coins
        self.email = email
        self.gender = gender
        self.activeRegion = activeRegion
        self.birthPlace = birthPlace
        self.educationalBackground = educationalBackground
        self.work = work
        self.height = height
        self.weight = weight
        self.bloodType = bloodType
        self.liquor = liquor
        self.cigarettes = cigarettes
        self.purpose = purpose
        self.datingExpenses = datingExpenses
        self.friendUids = friendUids
        self.introduction = introduction
        self.birthDate = birthDate
        self.profileImageURL = profileImageURL
        self.subProfileImageURL = subProfileImageURL
        self.hobbies = hobbies
        self.requestUids = requestUids
        self.requestedUids = requestedUids
        self.pairRequestUid = pairRequestUids
        self.pairRequestedUids = pairRequestedUids
        self.pairUid = pairUid
        self.pairID = pairID
        self.pairList = pairList
        self.chatUnreadNum = chatUnreadNum
    }
}
