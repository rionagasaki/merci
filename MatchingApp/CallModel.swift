//
//  CallModel.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/09/01.
//

import Foundation
import AmazonChimeSDK
import AVFoundation
import UIKit

class CallModel {
    private let cloudFunction: CloudFunctions
    let isGroupCall: Bool
    private var musicData: Data {
        guard let music = NSDataAsset(name: "Calling") else {
            return Data.init()
        }
        return music.data
    }
    
    private var audioObserver: AudioObserver {
        AudioObserver(isGroupCall: self.isGroupCall)
    }
    private let activeSpeakerObserver = AudioActiveSpeakerObserver()
    private let callRealTimeObserver = CallRealTimeObserver()
    var musicPlayer: AVAudioPlayer?
    var session: DefaultMeetingSession?
    
    init(cloudFunction: CloudFunctions = CloudFunctions(), isGroupCall: Bool) {
        self.cloudFunction = cloudFunction
        self.isGroupCall = isGroupCall
    }
    
    func startBgm(){
        do {
            self.musicPlayer = try AVAudioPlayer(data: musicData)
            self.musicPlayer?.prepareToPlay()
            self.musicPlayer?.numberOfLoops = -1
            self.musicPlayer?.play()
        } catch {
            print("Could not play music: \(error)")
        }
    }
    
    func stopBgm(){
        self.musicPlayer?.stop()
    }

    func startCall(user: UserObservableModel, completionHandler: (@escaping (Result<String, AppError>) -> Void)){
        let createCallModel = CloudFunctionsModel.CreateCall(userId: user.user.uid)
        cloudFunction.onCall(createCallModel){ [weak self] result in
            guard let weakSelf = self else { return }
            switch result {
            case .success(let joinMeetingResponse):
                let meetingResp = CloudFunctions.getCreateMeetingResponse(from: joinMeetingResponse)
                let attendeeResp = CloudFunctions.getCreateAttendeeResponse(from: joinMeetingResponse)
                weakSelf.session = DefaultMeetingSession(configuration: .init(createMeetingResponse: meetingResp, createAttendeeResponse: attendeeResp), logger: ConsoleLogger(name: ""))
                let audioSession = AVAudioSession.sharedInstance()
                do {
                    if let session = weakSelf.session {
                        weakSelf.startBgm()
                        try audioSession.setCategory(.playAndRecord, mode: .voiceChat, options:  [])
                        try audioSession.setActive(true)
                        try session.audioVideo.start()
                        
                        session.audioVideo.addAudioVideoObserver(observer: weakSelf.audioObserver)
                        session.audioVideo.addActiveSpeakerObserver(policy: DefaultActiveSpeakerPolicy(), observer: weakSelf.activeSpeakerObserver)
                        session.audioVideo.addRealtimeObserver(observer: weakSelf.callRealTimeObserver)
                        
                        completionHandler(.success(joinMeetingResponse.meeting.meetingInfo.meetingId))
                    }
                } catch {
                    completionHandler(.failure(.other(.unexpectedError)))
                }
            case .failure(let error):
                completionHandler(.failure(error))
            }
        }
    }
    
    func initOutputRoute(){
        if let audioDevices = session?.audioVideo.listAudioDevices() {
            if let bluetoothDevice = audioDevices.first(where: { $0.type == .audioBluetooth }) {
                self.session?.audioVideo.chooseAudioDevice(mediaDevice: bluetoothDevice)
            } else if let audioWiredHeadset = audioDevices.first(where: { $0.type == .audioWiredHeadset }) {
                self.session?.audioVideo.chooseAudioDevice(mediaDevice: audioWiredHeadset)
            }
            else if let builtInSpeakerDevice = audioDevices.first(where: { $0.type == .audioBuiltInSpeaker }) {
                self.session?.audioVideo.chooseAudioDevice(mediaDevice: builtInSpeakerDevice)
            } else if let handsetDevice = audioDevices.first(where: { $0.type == .audioHandset }) {
                self.session?.audioVideo.chooseAudioDevice(mediaDevice: handsetDevice)
            }
        }
    }
    
    func joinCall(
        user: UserObservableModel,
        channelId: String,
        completionHandler: @escaping(Result<Void, AppError>) -> Void
    ){
        let joinCall = CloudFunctionsModel.JoinCall(userId: user.user.uid, channelId: channelId)
        
        self.cloudFunction.onCall(joinCall) { [weak self] result in
            guard let weakSelf = self else { return }
            switch result {
            case .success(let joinMeetingResponse):
                let meetingResp = CloudFunctions.getCreateMeetingResponse(from: joinMeetingResponse)
                let attendeeResp = CloudFunctions.getCreateAttendeeResponse(from: joinMeetingResponse)
                weakSelf.session = DefaultMeetingSession(configuration: .init(
                    createMeetingResponse: meetingResp, createAttendeeResponse: attendeeResp), logger: ConsoleLogger(name: ""))
                let audioSession = AVAudioSession.sharedInstance()
                
                do {
                    if let session = weakSelf.session {
                        try audioSession.setCategory(.playAndRecord, mode: .voiceChat, options: [.duckOthers])
                        try audioSession.setActive(true)
                        try session.audioVideo.start()
                        session.audioVideo.addAudioVideoObserver(observer: weakSelf.audioObserver)
                        session.audioVideo.addActiveSpeakerObserver(policy: DefaultActiveSpeakerPolicy(), observer: weakSelf.activeSpeakerObserver)
                        session.audioVideo.addRealtimeObserver(observer: weakSelf.callRealTimeObserver)
                        let _ = session.audioVideo.realtimeSetVoiceFocusEnabled(enabled: true)
                        completionHandler(.success(()))
                    }
                } catch {
                    print(error)
                }
            case .failure(let error):
                completionHandler(.failure(.firestore(error)))
            }
        }
    }
    
    func stopCall(userId: String, channelId: String, completionHandler: @escaping(Result<Void, AppError>) -> Void){
        self.session?.audioVideo.stop()
        let deleteCall = CloudFunctionsModel.DeleteCall(
            userId: userId,
            channelId: channelId
        )
        self.cloudFunction.onCallWithNoResp(deleteCall){ result in
            switch result {
            case .success(_):
                completionHandler(.success(()))
            case .failure(let error):
                completionHandler(.failure(.firestore(error)))
            }
        }
    }
    
    func leaveCall(){
        self.session?.audioVideo.stop()
    }
    
    func muteAudio(isMuted: Bool, completionHandler: @escaping() -> Void){
        if isMuted {
            if let _ = self.session?.audioVideo.realtimeLocalUnmute(){
                completionHandler()
            }
        } else {
            if let _ = self.session?.audioVideo.realtimeLocalMute(){
                completionHandler()
            }
        }
    }
    
    func changeOutputRoute(isSpeaker: Bool, completionHandler: @escaping()->Void){
        let audioDevices = session?.audioVideo.listAudioDevices()
        if let bluetoothDevice = audioDevices?.first(where: { $0.type == .audioBluetooth }) {
                self.session?.audioVideo.chooseAudioDevice(mediaDevice: bluetoothDevice)
                return
            }
        
        if let audioWiredHeadset = audioDevices?.first(where: { $0.type == .audioWiredHeadset }) {
            self.session?.audioVideo.chooseAudioDevice(mediaDevice: audioWiredHeadset)
            return
        }
        
        if isSpeaker {
            if let handsetDevice = audioDevices?.first(where: { $0.type == .audioHandset }) {
                self.session?.audioVideo.chooseAudioDevice(mediaDevice: handsetDevice)
                completionHandler()
            }
        } else {
            if let speakerDevice = audioDevices?.first(where: { $0.type == .audioBuiltInSpeaker }) {
                self.session?.audioVideo.chooseAudioDevice(mediaDevice: speakerDevice)
                completionHandler()
            }
        }
    }
}



