//
//  CallMessageObserver.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/09/11.
//

import Foundation
import AmazonChimeSDK

class MyDataMessageObserver: DataMessageObserver {
    let dataMessageTopic = "chat"
    // A throttled message is returned by backend from local sender
    func dataMessageDidReceived(dataMessage: DataMessage) {
        
    }
}
