//
//  ConvertMapping.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/08/21.
//

import Foundation
import FirebaseFirestore

struct ConvertMapping {
    static func convertMapping(_ mapping: [String: Timestamp]) -> [String: String] {
        var newMapping: [String: String] = [:]
        for (key, value) in mapping {
            newMapping[key] = DateFormat.relativeDateFormat(date: value.dateValue())
        }
        return newMapping
    }
    
    static func convertMappingToBool(_ mapping: [String: Int], notice: [String]) -> [String] {
        var noticeNum = 0
        var newNotice:[String] = []
        for (_, value) in mapping {
            noticeNum += value
        }
        if noticeNum == 0 {
            newNotice = notice
        } else {
            newNotice = notice + ["message"]
        }
        return newNotice
    }
}
