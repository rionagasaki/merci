//
//  CloudFunctionsModel.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/08/17.
//

import Foundation

struct CloudFunctionsModel {
    
    
    struct CreateCall: CloudFunctionsModelable {
        typealias Response = JoinMeetingResponse
    
        var userId: String
        var functionsName: String = "createOrJoinMeeting"
        var requestParams: [String : Any] {
            return [
                "userId": userId,
            ]
        }
    }
    
    struct JoinCall: CloudFunctionsModelable {
        typealias Response = JoinMeetingResponse
        
        var userId: String
        var channelId: String
        var functionsName = "createOrJoinMeeting"
        
        var requestParams: [String : Any] {
            return [
                "channelId": channelId,
                "userId": userId
            ]
        }
    }
    
    struct DeleteCall: NoRespCloudFunctionsModelable {
        var userId: String
        var channelId: String
        var functionsName: String = "deleteMeeting"
    
        var requestParams: [String: Any] {
            return [
                "userId": userId,
                "channelId": channelId
            ]
        }
    }
}
