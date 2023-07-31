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
    var niniId: String
    var fcmToken: String
    var nickname: String
    var email: String
    var gender: String
    var profileImageURL: String
    var subProfileImageURLs: [String]
    var coins: Int
    var onboarding: Bool
    
    // プロフィール
    var activityRegion: String
    var birthDate: String
    var birthPlace: String
    var bloodType: String
    var cigarettes: String
    var datingExpenses: String
    var educationalBackground: String
    var height: String
    var hobbies: [String]
    var introduction: String
    var liquor: String
    var purpose: String
    var weight: String
    var work: String
    
    // ペアに関する情報
    var pairRequestUid: String
    var pairRequestedUids: [String]
    var pairUid: String
    var pairID: String
    var pairMapping: [String: String]
    var unreadMessageCount: [String: Int]
    
    init(document: QueryDocumentSnapshot){
        let userDic = document.data()
        self.id = document.documentID
        self.niniId = (userDic["niniId"] as? String).orEmpty
        self.fcmToken = (userDic["fcmToken"] as? String).orEmpty
        self.nickname = (userDic["nickname"] as? String).orEmpty
        self.email = (userDic["email"] as? String).orEmpty
        self.gender = (userDic["gender"] as? String).orEmpty
        self.profileImageURL = (userDic["profileImageURL"] as? String).orEmpty
        self.subProfileImageURLs = (userDic["subProfileImageURLs"] as? [String]).orEmptyArray
        self.coins = (userDic["coins"] as? Int).orEmptyNum
        self.onboarding = userDic["onboarding"] as? Bool ?? false
        
        
        self.activityRegion = (userDic["activityRegion"] as? String).orEmpty
        self.birthDate = (userDic["birthDate"] as? String).orEmpty
        self.birthPlace = (userDic["birthPlace"] as? String).orEmpty
        self.bloodType = (userDic["bloodType"] as? String).orEmpty
        self.cigarettes = (userDic["cigarettes"] as? String).orEmpty
        self.datingExpenses = (userDic["datingExpenses"] as? String).orEmpty
        self.educationalBackground = (userDic["educationalBackground"] as? String).orEmpty
        self.height = (userDic["height"] as? String).orEmpty
        self.hobbies = (userDic["hobbies"] as? [String]).orEmptyArray
        self.introduction = (userDic["introduction"] as? String).orEmpty
        self.liquor = (userDic["liquor"] as? String).orEmpty
        self.purpose = (userDic["purpose"] as? String).orEmpty
        self.weight = (userDic["weight"] as? String).orEmpty
        self.work = (userDic["work"] as? String).orEmpty
    
        
        self.pairRequestUid = (userDic["pairRequestUid"] as? String).orEmpty
        self.pairRequestedUids = (userDic["pairRequestedUids"] as? [String]).orEmptyArray
        self.pairUid = (userDic["pairUid"] as? String).orEmpty
        self.pairID = (userDic["pairID"] as? String).orEmpty
        self.pairMapping = (userDic["pairMapping"] as? [String: String] ?? [:])
        self.unreadMessageCount = (userDic["unreadMessageCount"] as? [String: Int] ?? [:])
    }
    
    init(document: DocumentSnapshot){
        let userDic = document.data()
        self.id = document.documentID
        self.niniId = (userDic?["niniId"] as? String).orEmpty
        self.fcmToken = (userDic?["fcmToken"] as? String).orEmpty
        self.nickname = (userDic?["nickname"] as? String).orEmpty
        self.email = (userDic?["email"] as? String).orEmpty
        self.profileImageURL = (userDic?["profileImageURL"] as? String).orEmpty
        self.subProfileImageURLs = (userDic?["subProfileImageURLs"] as? [String]).orEmptyArray
        self.coins = (userDic?["coins"] as? Int).orEmptyNum
        self.onboarding = userDic?["onboarding"] as? Bool ?? false
        
        self.activityRegion = (userDic?["activityRegion"] as? String).orEmpty
        self.birthDate = (userDic?["birthDate"] as? String).orEmpty
        self.birthPlace = (userDic?["birthPlace"] as? String).orEmpty
        self.bloodType = (userDic?["bloodType"] as? String).orEmpty
        self.cigarettes = (userDic?["cigarettes"] as? String).orEmpty
        self.datingExpenses = (userDic?["datingExpenses"] as? String).orEmpty
        self.educationalBackground = (userDic?["educationalBackground"] as? String).orEmpty
        self.gender = (userDic?["gender"] as? String).orEmpty
        self.height = (userDic?["height"] as? String).orEmpty
        self.hobbies = (userDic?["hobbies"] as? [String]).orEmptyArray
        self.introduction = (userDic?["introduction"] as? String).orEmpty
        self.liquor = (userDic?["liquor"] as? String).orEmpty
        self.purpose = (userDic?["purpose"] as? String).orEmpty
        self.weight = (userDic?["weight"] as? String).orEmpty
        self.work = (userDic?["work"] as? String).orEmpty
        
        self.pairRequestUid = (userDic?["pairRequestUid"] as? String).orEmpty
        self.pairRequestedUids = (userDic?["pairRequestedUids"] as? [String]).orEmptyArray
        self.pairUid = (userDic?["pairUid"] as? String).orEmpty
        self.pairID = (userDic?["pairID"] as? String).orEmpty
        self.pairMapping = (userDic?["pairMapping"] as? [String: String] ?? [:])
        self.unreadMessageCount = (userDic?["unreadMessageCount"] as? [String: Int] ?? [:])
    }
    
    func adaptUserObservableModel() -> UserModel {
        return .init(
            uid: self.id,
            niniId: self.niniId,
            fcmToken: self.fcmToken,
            nickname: self.nickname,
            email: self.email,
            gender: self.gender,
            profileImageURL: self.profileImageURL,
            subProfileImageURL: self.subProfileImageURLs,
            coins: self.coins,
            onboarding: self.onboarding,
            activeRegion: self.activityRegion,
            birthDate: self.birthDate,
            birthPlace: self.birthPlace,
            bloodType: self.bloodType,
            cigarettes: self.cigarettes,
            datingExpenses: self.datingExpenses,
            educationalBackground: self.educationalBackground,
            height: self.height,
            hobbies: self.hobbies,
            introduction: self.introduction,
            liquor: self.liquor,
            purpose: self.purpose,
            weight: self.weight,
            work: self.work,
            pairRequestUid: self.pairRequestUid,
            pairRequestedUids: self.pairRequestedUids,
            pairUid: self.pairUid,
            pairID: self.pairID,
            pairMapping: self.pairMapping,
            unreadMessageCount: self.unreadMessageCount
        )
    }
}

struct UserModel {
    var uid: String = ""
    var niniId: String = ""
    var fcmToken: String = ""
    var nickname: String = ""
    var email: String = ""
    var gender: String = ""
    var profileImageURL: String = ""
    var subProfileImageURL: [String] = []
    var coins: Int = 0
    var onboarding: Bool = false
    
    var activeRegion: String = ""
    var birthDate: String = ""
    var birthPlace: String = ""
    var bloodType: String = ""
    var cigarettes: String = ""
    var datingExpenses: String = ""
    var educationalBackground: String = ""
    var height: String = ""
    var hobbies: [String] = []
    var introduction:String = ""
    var liquor: String = ""
    var purpose: String = ""
    var weight: String = ""
    var work: String = ""
    
    var pairRequestUid: String = ""
    var pairRequestedUids: [String] = []
    var pairUid: String = ""
    var pairID: String = ""
    var pairMapping: [String:String] = [:]
    var unreadMessageCount:[String: Int] = [:]
}

// User情報を管理するObservableObject
final class UserObservableModel: ObservableObject, Identifiable {
    @Published var user: UserModel = .init()
    
    init(userModel: UserModel){
        self.user = userModel
    }
    let genders = ["🙋‍♂️男性", "💁‍♀️女性"]
    let tokyo23Wards = ["千代田区", "中央区", "港区", "新宿区", "文京区", "台東区", "墨田区", "江東区", "品川区", "目黒区", "大田区", "世田谷区", "渋谷区", "中野区", "杉並区", "豊島区", "北区", "荒川区", "板橋区", "練馬区", "足立区", "葛飾区", "江戸川区"]

    func initial(){
        self.user = .init()
    }
}
