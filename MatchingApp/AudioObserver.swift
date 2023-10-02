//
//  AudioObserver.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/09/11.
//

import Foundation
import AmazonChimeSDK
import SwiftUI

class AudioObserver: AudioVideoObserver {
    @ObservedObject var realTimeCallStatus = RealTimeCallStatus.shared
    private let userService = UserFirestoreService()
    private let chatService = ChatFirestoreService()
    private let callService = CallFirestoreService()
    let isGroupCall: Bool
    
    init(isGroupCall: Bool){
        self.isGroupCall = isGroupCall
    }
    
    
    func remoteVideoSourcesDidBecomeAvailable(sources: [AmazonChimeSDK.RemoteVideoSource]) {}
    
    func remoteVideoSourcesDidBecomeUnavailable(sources: [AmazonChimeSDK.RemoteVideoSource]){}
    
    func cameraSendAvailabilityDidChange(available: Bool) {}
    
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
        if isGroupCall {
            if realTimeCallStatus.isHostUid.isEmpty {
                self.callService.stopCallConcurrentlly(
                    userIDs: realTimeCallStatus.callingUser,
                    channelID: realTimeCallStatus.channelId
                ) { [weak self] result in
                    guard let weakSelf = self else { return }
                    switch result {
                    case .success(_):
                        weakSelf.realTimeCallStatus.initial()
                    case .failure(_):
                        break
                    }
                }
            }
        }
    }
    
    func audioSessionDidCancelReconnect() {}
    func connectionDidRecover() {}
    func connectionDidBecomePoor() {}
    func videoSessionDidStartConnecting() {}
    func videoSessionDidStartWithStatus(sessionStatus: MeetingSessionStatus) {}
    func videoSessionDidStopWithStatus(sessionStatus: MeetingSessionStatus) {}
}
