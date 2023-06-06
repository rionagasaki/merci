//
//  Pair.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/06/01.
//

import Foundation
import FirebaseFirestore

class Pair {
    var id: String
    var gender: String
    var pair_1_uid: String
    var pair_1_nickname: String
    var pair_1_profileImageURL: String
    var pair_1_activeRegion: String
    var pair_1_birthDate: String
    var pair_2_uid: String
    var pair_2_nickname: String
    var pair_2_profileImageURL: String
    var pair_2_activeRegion: String
    var pair_2_birthDate: String
    var chatPairIDs: [String: Any]
    var chatPairLastMessage: [String: String]
    var chatPairLastCreatedAt: [String: Timestamp]
    
    init(document: QueryDocumentSnapshot){
        let userDic = document.data()
        self.id = document.documentID
        self.gender = (userDic["gender"] as? String).orEmpty
        self.pair_1_uid = (userDic["pair_1_uid"] as? String).orEmpty
        self.pair_1_nickname = (userDic["pair_1_nickname"] as? String).orEmpty
        self.pair_1_profileImageURL = (userDic["pair_1_profileImageURL"] as? String).orEmpty
        self.pair_1_activeRegion = (userDic["pair_1_activeRegion"] as? String).orEmpty
        self.pair_1_birthDate = (userDic["pair_1_birthDate"] as? String).orEmpty
        self.pair_2_uid = (userDic["pair_2_uid"] as? String).orEmpty
        self.pair_2_nickname = (userDic["pair_2_nickname"] as? String).orEmpty
        self.pair_2_profileImageURL = (userDic["pair_2_profileImageURL"] as? String).orEmpty
        self.pair_2_activeRegion = (userDic["pair_2_activeRegion"] as? String).orEmpty
        self.pair_2_birthDate = (userDic["pair_2_birthDate"] as? String).orEmpty
        self.chatPairIDs = (userDic["chatPairIDs"] as? [String: Any]) ?? [:]
        self.chatPairLastMessage = (userDic["chatPairLastMessage"] as? [String: String]) ?? [:]
        self.chatPairLastCreatedAt = (userDic["chatPairLastCreatedAt"] as? [String: Timestamp]) ?? [:]
    }
    
    init(document: DocumentSnapshot){
        let userDic = document.data()
        self.id = document.documentID
        self.gender = (userDic?["gender"] as? String).orEmpty
        self.pair_1_uid = (userDic?["pair_1_uid"] as? String).orEmpty
        self.pair_1_nickname = (userDic?["pair_1_nickname"] as? String).orEmpty
        self.pair_1_profileImageURL = (userDic?["pair_1_profileImageURL"] as? String).orEmpty
        self.pair_1_activeRegion = (userDic?["pair_1_activeRegion"] as? String).orEmpty
        self.pair_1_birthDate = (userDic?["pair_1_birthDate"] as? String).orEmpty
        self.pair_2_uid = (userDic?["pair_2_uid"] as? String).orEmpty
        self.pair_2_nickname = (userDic?["pair_2_nickname"] as? String).orEmpty
        self.pair_2_profileImageURL = (userDic?["pair_2_profileImageURL"] as? String).orEmpty
        self.pair_2_activeRegion = (userDic?["pair_2_activeRegion"] as? String).orEmpty
        self.pair_2_birthDate = (userDic?["pair_2_birthDate"] as? String).orEmpty
        self.chatPairIDs = (userDic?["chatPairIDs"] as? [String: Any]) ?? [:]
        self.chatPairLastMessage = (userDic?["chatPairLastMessage"] as? [String: String]) ?? [:]
        self.chatPairLastCreatedAt = (userDic?["chatPairLastCreatedAt"] as? [String: Timestamp]) ?? [:]
    }
}


// User情報を管理するObservableObject
final class PairObservableModel: ObservableObject, Identifiable {
    @Published var id: String = ""
    @Published var gender: String = ""
    @Published var pair_1_uid: String = ""
    @Published var pair_1_nickname: String = ""
    @Published var pair_1_profileImageURL: String = ""
    @Published var pair_1_activeRegion: String = ""
    @Published var pair_1_birthDate: String = ""
    @Published var pair_2_uid: String = ""
    @Published var pair_2_nickname: String = ""
    @Published var pair_2_profileImageURL: String = ""
    @Published var pair_2_activeRegion: String = ""
    @Published var pair_2_birthDate: String = ""
    @Published var chatPairIDs: [String: Any] = [:]
    @Published var chatPairLastMessage:[String: String] = [:]
    @Published var chatPairLastCreatedAt: [String: Timestamp] = [:]
    
    init(id: String = "", gender: String = "", pair_1_uid:String = "",pair_1_nickname: String = "", pair_1_profileImageURL: String = "", pair_1_activeRegion:String = "", pair_1_birthDate: String = "",pair_2_uid:String = "",pair_2_nickname: String = "", pair_2_profileImageURL: String = "", pair_2_activeRegion:String = "", pair_2_birthDate: String = "", chatPairIDs: [String: Any] = [:], chatPairLastMessage: [String: String] = [:], chatPairLastCreatedAt:[String: Timestamp] = [:]){
        self.id = id
        self.gender = gender
        self.pair_1_uid = pair_1_uid
        self.pair_1_nickname = pair_1_nickname
        self.pair_1_profileImageURL = pair_1_profileImageURL
        self.pair_1_activeRegion = pair_1_activeRegion
        self.pair_1_birthDate = pair_1_birthDate
        self.pair_2_uid = pair_2_uid
        self.pair_2_nickname = pair_2_nickname
        self.pair_2_profileImageURL = pair_2_profileImageURL
        self.pair_2_activeRegion = pair_2_activeRegion
        self.pair_2_birthDate = pair_2_birthDate
        self.chatPairIDs = chatPairIDs
        self.chatPairLastMessage = chatPairLastMessage
        self.chatPairLastCreatedAt = chatPairLastCreatedAt
    }
}
