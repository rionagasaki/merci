//
//  ActiveSpeakerObserver.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/09/11.
//

import Foundation
import SwiftUI
import AmazonChimeSDK

class AudioActiveSpeakerObserver: ActiveSpeakerObserver {
    let activeSpeakerObserverId = UUID().uuidString

    var observerId: String {
        return activeSpeakerObserverId
    }

    func activeSpeakerDidDetect(attendeeInfo: [AttendeeInfo]) {
        if !attendeeInfo.isEmpty {
            print(attendeeInfo)
        }
    }

    var scoresCallbackIntervalMs: Int {
        return 500
    }

    func activeSpeakerScoreDidChange(scores: [AttendeeInfo: Double]) {
        scores.forEach { (score) in
            let (key, value) = score
            RealTimeCallStatus.shared.scores[key.externalUserId] = value
        }
    }
}
