//
//  CallViewModel.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/08/06.
//

import Foundation
import Combine
import AmazonChimeSDK

class HostCallViewModel: ObservableObject {
    private var cancellable = Set<AnyCancellable>()
    private let setToFirestore = SetToFirestore.init()
    private let fetchFromFirestore = FetchFromFirestore.init()
    private let cloudFunctions: CloudFunctionsService
    
    // 通話ホストの場合、最初はCallObservableObjectは存在しないので、channelIdが必要。
    @Published var channelId: String = ""
    @Published var call: CallObservableModel?
    @Published var isMuted: Bool = false
    @Published var isAlertDeleteCall: Bool = false
    @Published var isSuccessDeleteCall: Bool = false
    @Published var isErrorAlert: Bool = false
    @Published var errorMessage: String = ""
    @Published var session: DefaultMeetingSession?
    
    init(cloudFunctions: CloudFunctionsService = CloudFunctions()){
        self.cloudFunctions = cloudFunctions
    }
    
    func startCalling(userModel: UserObservableModel, channelTitle: String) {
        let createCallModel = CloudFunctionsModel.CreateCall(user: userModel, channelTitle: channelTitle)
        cloudFunctions.onCall(createCallModel)
            .sink { completion in
                switch completion {
                case .finished:
                    self.initialCallInfo(channelId: self.channelId)
                case .failure(let error):
                    self.isErrorAlert = true
                    self.errorMessage = error.errorMessage
                }
            } receiveValue: { joinMeetingResponse in
                self.channelId = joinMeetingResponse.meeting.meetingInfo.meetingId
                let meetingResp = CloudFunctions.getCreateMeetingResponse(from: joinMeetingResponse)
                let attendeeResp = CloudFunctions.getCreateAttendeeResponse(from: joinMeetingResponse)
                self.session = DefaultMeetingSession(configuration: .init(createMeetingResponse: meetingResp, createAttendeeResponse: attendeeResp), logger: ConsoleLogger(name: ""))
                do {
                    if let session = self.session {
                        try session.audioVideo.start()
                    }
                } catch {
                    print(error)
                }
            }
            .store(in: &self.cancellable)
    }
    
    func joinCall(callInfo: CallObservableModel, userModel: UserObservableModel) {
        let joinCall = CloudFunctionsModel.JoinCall(user: userModel, channelId: callInfo.call.channelId)
        self.cloudFunctions.onCall(joinCall)
            .sink { completion in
                switch completion {
                case .finished:
                    self.initialCallInfo(channelId: callInfo.call.channelId)
                case .failure(let error):
                    self.isErrorAlert = true
                    self.errorMessage = error.errorMessage
                }
            } receiveValue: { joinMeetingResponse in
                let meetingResp = CloudFunctions.getCreateMeetingResponse(from: joinMeetingResponse)
                let attendeeResp = CloudFunctions.getCreateAttendeeResponse(from: joinMeetingResponse)
                self.session = DefaultMeetingSession(configuration: .init(createMeetingResponse: meetingResp, createAttendeeResponse: attendeeResp), logger: ConsoleLogger(name: ""))
                do {
                    if let session = self.session {
                        try session.audioVideo.start()
                        let _ = session.audioVideo.realtimeSetVoiceFocusEnabled(enabled: true)
                    }
                } catch {
                    print(error)
                }
            }
            .store(in: &self.cancellable)
    }
    
    func initialCallInfo(channelId:String){
        self.fetchFromFirestore
            .observeChannelById(channelId: channelId)
            .sink { completion in
                switch completion {
                case .finished:
                    
                    print("successfully fetch call data")
                case .failure(let error):
                    self.isErrorAlert = true
                    self.errorMessage = error.errorMessage
                }
            } receiveValue: { call in
                self.call = call
            }
            .store(in: &self.cancellable)
    }
    
    // ユーザー(ホスト以外)が離脱
    func leaveChannel(session: DefaultMeetingSession?){
        session?.audioVideo.stop()
    }
    
    // ホストが離脱(通話の終了)
    func finishChannel(callInfo:CallObservableModel){
        let deleteCall = CloudFunctionsModel.DeleteCall(channelId: callInfo.call.channelId)
        self.cloudFunctions.onCallWithNoResp(deleteCall)
            .sink { completion in
                switch completion {
                case .finished:
                    self.isSuccessDeleteCall = true
                case .failure(let error):
                    print(error)
                    self.isErrorAlert = true
                    self.errorMessage = error.errorMessage
                }
            } receiveValue: { _ in
                print("successfully delete channel")
            }
            .store(in: &self.cancellable)
    }
    
    // ミュートする
    func muteAudio(session: DefaultMeetingSession?){
        if self.isMuted {
            if let _ = session?.audioVideo.realtimeLocalUnmute(){
                self.isMuted = false
            }
        } else {
            if let _ = session?.audioVideo.realtimeLocalMute(){
                self.isMuted = true
            }
        }
    }
    
    func changeOutputRoute(session: DefaultMeetingSession?){
        let audioOutputDevices  = session?.audioVideo.listAudioDevices()
        if let defaultSpeaker = audioOutputDevices?.first {
            
        }
    }
}
