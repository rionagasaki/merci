//
//  CallRealTimeObserver.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/09/11.
//

import Foundation
import AmazonChimeSDK

class CallRealTimeObserver: RealtimeObserver {
    func volumeDidChange(volumeUpdates: [VolumeUpdate]) {
        for _ in volumeUpdates {}
    }
    func signalStrengthDidChange(signalUpdates: [SignalUpdate]) {
        for _ in signalUpdates {}
    }
    func attendeesDidJoin(attendeeInfo: [AttendeeInfo]) {
        for _ in attendeeInfo {}
    }
    func attendeesDidLeave(attendeeInfo: [AttendeeInfo]) {
        for currentAttendeeInfo in attendeeInfo {
            print("DidLeaveUser", currentAttendeeInfo.externalUserId)
        }
    }
    func attendeesDidDrop(attendeeInfo: [AttendeeInfo]) {
        for currentAttendeeInfo in attendeeInfo {
            RealTimeCallStatus.shared.dropUser.append(currentAttendeeInfo.externalUserId)
        }
    }
    func attendeesDidMute(attendeeInfo: [AttendeeInfo]) {
        for _ in attendeeInfo {
        }
    }
    func attendeesDidUnmute(attendeeInfo: [AttendeeInfo]) {
        for _ in attendeeInfo {
            
        }
    }
}
