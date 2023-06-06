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
    var nickname: String
    var email: String
    var gender: String
    var birthDate: String
    var introduction: String
    var profileImageURL: String
    var subProfileImageURLs: [String]
    var activityRegion: String
    var requestUids: [String]
    var requestedUids: [String]
    var hobbies: [String]
    var pairUid:String
    var pairID: String
    
    init(document: QueryDocumentSnapshot){
        let userDic = document.data()
        self.id = document.documentID
        self.nickname = (userDic["nickname"] as? String).orEmpty
        self.email = (userDic["email"] as? String).orEmpty
        self.profileImageURL = (userDic["profileImageURL"] as? String).orEmpty
        self.subProfileImageURLs = (userDic["subProfileImageURLs"] as? [String]).orEmptyArray
        self.birthDate = (userDic["birthDate"] as? String).orEmpty
        self.gender = (userDic["gender"] as? String).orEmpty
        self.activityRegion = (userDic["activityRegion"] as? String).orEmpty
        self.introduction = (userDic["introduction"] as? String).orEmpty
        self.requestUids = (userDic["requestUid"] as? [String]).orEmptyArray
        self.requestedUids = (userDic["requestedUid"] as? [String]).orEmptyArray
        self.hobbies = (userDic["hobbies"] as? [String]).orEmptyArray
        self.pairUid = (userDic["pairUid"] as? String).orEmpty
        self.pairID = (userDic["pairID"] as? String).orEmpty
    }
    
    init(document: DocumentSnapshot){
        let userDic = document.data()
        self.id = document.documentID
        self.nickname = (userDic?["nickname"] as? String).orEmpty
        self.email = (userDic?["email"] as? String).orEmpty
        self.profileImageURL = (userDic?["profileImageURL"] as? String).orEmpty
        self.subProfileImageURLs = (userDic?["subProfileImageURLs"] as? [String]).orEmptyArray
        self.birthDate = (userDic?["birthDate"] as? String).orEmpty
        self.gender = (userDic?["gender"] as? String).orEmpty
        self.activityRegion = (userDic?["activityRegion"] as? String).orEmpty
        self.introduction = (userDic?["introduction"] as? String).orEmpty
        self.requestUids = (userDic?["requestUid"] as? [String]).orEmptyArray
        self.requestedUids = (userDic?["requestedUid"] as? [String]).orEmptyArray
        self.hobbies = (userDic?["hobbies"] as? [String]).orEmptyArray
        self.pairUid = (userDic?["pairUid"] as? String).orEmpty
        self.pairID = (userDic?["pairID"] as? String).orEmpty
    }
}


// User情報を管理するObservableObject
final class UserObservableModel: ObservableObject {
    @Published var uid: String = ""
    @Published var nickname: String = ""
    @Published var email: String = ""
    @Published var gender: String = ""
    @Published var activeRegion: String = ""
    @Published var introduction:String = ""
    @Published var birthDate: String = ""
    @Published var profileImageURL: String = ""
    @Published var subProfileImageURL: [String] = []
    @Published var hobbies: [String] = []
    @Published var requestUids: [String] = []
    @Published var requestedUids:[String] = []
    @Published var pairUid: String = ""
    @Published var pairID: String = ""
    let genders = ["男性", "女性"]
    let tokyo23Wards = ["千代田区", "中央区", "港区", "新宿区", "文京区", "台東区", "墨田区", "江東区", "品川区", "目黒区", "大田区", "世田谷区", "渋谷区", "中野区", "杉並区", "豊島区", "北区", "荒川区", "板橋区", "練馬区", "足立区", "葛飾区", "江戸川区"]
}
