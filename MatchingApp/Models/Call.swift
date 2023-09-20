//
//  Call.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/08/05.
//

import Foundation
import FirebaseFirestore

class Call {
    var channelId: String
    var channelTitle: String
    var hostUserId: String
    var hostUserImageUrlString: String
    var userIdToUserIconImageUrlString: [String: String]
    var userIdToUserName: [String: String]
    var callingNow: Bool
    var isFriendCalling: Bool
    var createdAt: Timestamp

    init(document: QueryDocumentSnapshot) {
        self.channelId = document.documentID
        let callInfoDic = document.data()
        self.channelTitle = (callInfoDic["channelTitle"] as? String).orEmpty
        self.hostUserId = (callInfoDic["hostUserId"] as? String).orEmpty
        self.hostUserImageUrlString = (callInfoDic["hostUserImageUrlString"] as? String).orEmpty
        self.userIdToUserIconImageUrlString = (callInfoDic["userIdToUserIconImageUrlString"] as? [String: String]) ?? [:]
        self.userIdToUserName = (callInfoDic["userIdToUserName"] as? [String: String]) ?? [:]
        self.isFriendCalling = (callInfoDic["isFriendCalling"] as? Bool) ?? false
        self.callingNow = (callInfoDic["callingNow"] as? Bool) ?? false
        self.createdAt = (callInfoDic["createdAt"] as? Timestamp) ?? Timestamp()
    }

    init(document: DocumentSnapshot) {
        self.channelId = document.documentID
        let callInfoDic = document.data()
        self.channelTitle = (callInfoDic?["channelTitle"] as? String).orEmpty
        self.hostUserId = (callInfoDic?["hostUserId"] as? String).orEmpty
        self.hostUserImageUrlString = (callInfoDic?["hostUserImageUrlString"] as? String).orEmpty
        self.userIdToUserIconImageUrlString = (callInfoDic?["userIdToUserIconImageUrlString"] as? [String: String]) ?? [:]
        self.userIdToUserName = (callInfoDic?["userIdToUserName"] as? [String: String]) ?? [:]
        self.isFriendCalling = (callInfoDic?["isFriendCalling"] as? Bool) ?? false
        self.callingNow = (callInfoDic?["callingNow"] as? Bool) ?? false
        self.createdAt = (callInfoDic?["createdAt"] as? Timestamp) ?? Timestamp()
    }

    func adaptCall() -> CallModel {
        return .init(
            channelId: self.channelId,
            channelTitle: self.channelTitle,
            hostUserId: self.hostUserId,
            hostUserImageUrlString: self.hostUserImageUrlString,
            userIdToUserIconImageUrlString: self.userIdToUserIconImageUrlString,
            userIdToUserName: self.userIdToUserName,
            isFriendCalling: self.isFriendCalling,
            callingNow: self.callingNow,
            createdAt: DateFormat.relativeDateFormat(date: self.createdAt.dateValue())
        )
    }
    
    struct CallModel {
        var channelId: String = ""
        var channelTitle: String = ""
        var hostUserId: String = ""
        var hostUserImageUrlString: String = ""
        var userIdToUserIconImageUrlString: [String: String] = [:]
        var userIdToUserName: [String: String] = [:]
        var isFriendCalling: Bool = false
        var callingNow: Bool = false
        var createdAt: String = ""
    }
}

final class CallObservableModel: ObservableObject, Identifiable {
    @Published var call: Call.CallModel = .init()

    init(callModel: Call.CallModel) {
        self.call = callModel
    }

    func initial() {
        self.call = .init()
    }
}
