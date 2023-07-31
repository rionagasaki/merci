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
    var isCurrentPair: Bool
    var gender: String
    
    var pair_1_uid: String
    var pair_1_nickname: String
    var pair_1_profileImageURL: String
    var pair_1_activeRegion: String
    var pair_1_birthDate: String
    var pair_1_fcmToken: String
    
    var pair_2_uid: String
    var pair_2_nickname: String
    var pair_2_profileImageURL: String
    var pair_2_activeRegion: String
    var pair_2_birthDate: String
    var pair_2_fcmToken: String
    
    var chatPairIDs: [String: String]
    var chatPairLastMessage: [String: String]
    var chatPairLastCreatedAt: [String: Timestamp]
    
    init(document: QueryDocumentSnapshot){
        let userDic = document.data()
        self.id = document.documentID
        self.isCurrentPair = (userDic["isCurrentPair"] as? Bool ?? false)
        self.gender = (userDic["gender"] as? String).orEmpty
        
        self.pair_1_uid = (userDic["pair_1_uid"] as? String).orEmpty
        self.pair_1_nickname = (userDic["pair_1_nickname"] as? String).orEmpty
        self.pair_1_profileImageURL = (userDic["pair_1_profileImageURL"] as? String).orEmpty
        self.pair_1_activeRegion = (userDic["pair_1_activeRegion"] as? String).orEmpty
        self.pair_1_birthDate = (userDic["pair_1_birthDate"] as? String).orEmpty
        self.pair_1_fcmToken = (userDic["pair_1_fcmToken"] as? String).orEmpty
        
        self.pair_2_uid = (userDic["pair_2_uid"] as? String).orEmpty
        self.pair_2_nickname = (userDic["pair_2_nickname"] as? String).orEmpty
        self.pair_2_profileImageURL = (userDic["pair_2_profileImageURL"] as? String).orEmpty
        self.pair_2_activeRegion = (userDic["pair_2_activeRegion"] as? String).orEmpty
        self.pair_2_birthDate = (userDic["pair_2_birthDate"] as? String).orEmpty
        self.pair_2_fcmToken = (userDic["pair_2_fcmToken"] as? String).orEmpty
        
        self.chatPairIDs = (userDic["chatPairIDs"] as? [String: String]) ?? [:]
        self.chatPairLastMessage = (userDic["chatPairLastMessage"] as? [String: String]) ?? [:]
        self.chatPairLastCreatedAt = (userDic["chatPairLastCreatedAt"] as? [String: Timestamp]) ?? [:]
    }
    
    init(document: DocumentSnapshot){
        let userDic = document.data()
        self.id = document.documentID
        self.isCurrentPair = (userDic?["isCurrentPair"] as? Bool ?? false)
        self.gender = (userDic?["gender"] as? String).orEmpty
        
        self.pair_1_uid = (userDic?["pair_1_uid"] as? String).orEmpty
        self.pair_1_nickname = (userDic?["pair_1_nickname"] as? String).orEmpty
        self.pair_1_profileImageURL = (userDic?["pair_1_profileImageURL"] as? String).orEmpty
        self.pair_1_activeRegion = (userDic?["pair_1_activeRegion"] as? String).orEmpty
        self.pair_1_birthDate = (userDic?["pair_1_birthDate"] as? String).orEmpty
        self.pair_1_fcmToken = (userDic?["pair_1_fcmToken"] as? String).orEmpty
        
        self.pair_2_uid = (userDic?["pair_2_uid"] as? String).orEmpty
        self.pair_2_nickname = (userDic?["pair_2_nickname"] as? String).orEmpty
        self.pair_2_profileImageURL = (userDic?["pair_2_profileImageURL"] as? String).orEmpty
        self.pair_2_activeRegion = (userDic?["pair_2_activeRegion"] as? String).orEmpty
        self.pair_2_birthDate = (userDic?["pair_2_birthDate"] as? String).orEmpty
        self.pair_2_fcmToken = (userDic?["pair_2_fcmToken"] as? String).orEmpty
        
        self.chatPairIDs = (userDic?["chatPairIDs"] as? [String: String]) ?? [:]
        self.chatPairLastMessage = (userDic?["chatPairLastMessage"] as? [String: String]) ?? [:]
        self.chatPairLastCreatedAt = (userDic?["chatPairLastCreatedAt"] as? [String: Timestamp]) ?? [:]
    }
    
    func adaptPairModel() -> PairModel {
        return .init(
            id: self.id,
            isCurrentPair: self.isCurrentPair,
            gender: self.gender,
            
            pair_1_uid: self.pair_1_uid,
            pair_1_nickname: self.pair_1_nickname,
            pair_1_profileImageURL: self.pair_1_profileImageURL,
            pair_1_activeRegion: self.pair_1_activeRegion,
            pair_1_birthDate: self.pair_1_birthDate,
            pair_1_fmcToken: self.pair_1_fcmToken,
            
            pair_2_uid: self.pair_2_uid,
            pair_2_nickname: self.pair_2_nickname,
            pair_2_profileImageURL: self.pair_2_profileImageURL,
            pair_2_activeRegion: self.pair_2_activeRegion,
            pair_2_birthDate: self.pair_2_birthDate,
            pair_2_fcmToken: self.pair_2_fcmToken,
            
            chatPairIDs: self.chatPairIDs,
            chatPairLastMessage: self.chatPairLastMessage,
            chatPairLastCreatedAt: self.chatPairLastCreatedAt
        )
    }
}


struct PairModel {
    var id: String = ""
    var isCurrentPair: Bool = false
    var gender: String = ""
    var pair_1_uid: String = ""
    var pair_1_nickname: String = ""
    var pair_1_profileImageURL: String = ""
    var pair_1_activeRegion: String = ""
    var pair_1_birthDate: String = ""
    var pair_1_fmcToken: String = ""
    var pair_2_uid: String = ""
    var pair_2_nickname: String = ""
    var pair_2_profileImageURL: String = ""
    var pair_2_activeRegion: String = ""
    var pair_2_birthDate: String = ""
    var pair_2_fcmToken: String = ""
    var chatPairIDs: [String: String] = [:]
    var chatPairLastMessage:[String: String] = [:]
    var chatPairLastCreatedAt: [String: Timestamp] = [:]
}


// User情報を管理するObservableObject
final class PairObservableModel: ObservableObject, Identifiable {
    @Published var pair: PairModel = .init()
    init(pairModel: PairModel){
        self.pair = pairModel
    }
    
    func initial(){
        self.pair = .init()
    }
}
