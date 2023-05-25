//
//  User.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/22.
//

import Foundation
import FirebaseFirestore

class User {
    var nickname: String
    var email: String
    var gender: String
    var birthDate: String
    var profileImageURL: String
    var activityRegion: String

    init(document: QueryDocumentSnapshot){
        let userDic = document.data()
        self.nickname = (userDic["nickname"] as? String).orEmpty
        self.email = (userDic["email"] as? String).orEmpty
        self.profileImageURL = (userDic["profileImageURL"] as? String).orEmpty
        self.birthDate = (userDic["birthDate"] as? String).orEmpty
        self.gender = (userDic["gender"] as? String).orEmpty
        self.activityRegion = (userDic["activityRegion"] as? String).orEmpty
    }
    
    init(document: DocumentSnapshot){
        let userDic = document.data()
        self.nickname = (userDic?["nickname"] as? String).orEmpty
        self.email = (userDic?["email"] as? String).orEmpty
        self.profileImageURL = (userDic?["profileImageURL"] as? String).orEmpty
        self.birthDate = (userDic?["birthDate"] as? String).orEmpty
        self.gender = (userDic?["gender"] as? String).orEmpty
        self.activityRegion = (userDic?["activityRegion"] as? String).orEmpty
    }
}

final class UserObservableModel: ObservableObject {
    @Published var nickname: String = ""
    @Published var email: String = ""
    @Published var gender: String = ""
    @Published var activeRegion: String = ""
    @Published var introduction:String = ""
    @Published var birthDate: String = ""
    @Published var profileImageURL: String = ""
    let genders = ["男性", "女性"]
    
    let tokyo23Wards = ["千代田区", "中央区", "港区", "新宿区", "文京区", "台東区", "墨田区", "江東区", "品川区", "目黒区", "大田区", "世田谷区", "渋谷区", "中野区", "杉並区", "豊島区", "北区", "荒川区", "板橋区", "練馬区", "足立区", "葛飾区", "江戸川区"]
}
