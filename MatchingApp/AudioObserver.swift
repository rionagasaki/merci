//
//  AudioObserver.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/09/11.
//

import Foundation
import AmazonChimeSDK

class AudioObserver: AudioVideoObserver {
    func remoteVideoSourcesDidBecomeAvailable(sources: [AmazonChimeSDK.RemoteVideoSource]) {
        
    }
    
    func remoteVideoSourcesDidBecomeUnavailable(sources: [AmazonChimeSDK.RemoteVideoSource]) {
        
    }
    
    func cameraSendAvailabilityDidChange(available: Bool) {
        
    }
    
    func audioSessionDidStartConnecting(reconnecting: Bool) {
        if (reconnecting) {
            print("繋がったよ！！")
        }
        
    }
    func audioSessionDidStart(reconnecting: Bool) {
        
    }
    func audioSessionDidDrop() {
        
    }
    func audioSessionDidStopWithStatus(sessionStatus: MeetingSessionStatus) {
         // See the "Stopping a session" section for details.
    }
    func audioSessionDidCancelReconnect() {}
    func connectionDidRecover() {}
    func connectionDidBecomePoor() {}
    func videoSessionDidStartConnecting() {}
    func videoSessionDidStartWithStatus(sessionStatus: MeetingSessionStatus) {
        
    }
    func videoSessionDidStopWithStatus(sessionStatus: MeetingSessionStatus) {}
}
