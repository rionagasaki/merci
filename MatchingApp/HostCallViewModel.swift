//
//  CallViewModel.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/08/06.
//

import Foundation
import Combine
import AmazonChimeSDK
import AVFoundation
import UIKit

class HostCallViewModel: ObservableObject {
    private var cancellable = Set<AnyCancellable>()
    private let callService = CallFirestoreService()
    private let userService = UserFirestoreService()
    private let musicData = NSDataAsset(name: "CallMusic")!.data
    private let callModel = CallModel()
    // 通話ホストの場合、最初はCallObservableObjectは存在しないので、channelIdが必要。
    var musicPlayer:AVAudioPlayer?
    @Published var channelId: String = ""
    @Published var isFirstFetchCallInfo: Bool = true
    @Published var call: CallObservableModel?
    @Published var isLoading: Bool = false
    @Published var isBgm: Bool = false
    @Published var isMuted: Bool = false
    @Published var isSpeaker: Bool = false
    @Published var isAlertDeleteCall: Bool = false
    @Published var isSuccessDeleteCall: Bool = false
    @Published var isErrorAlert: Bool = false
    @Published var errorMessage: String = ""
    
    func startCalling(user: UserObservableModel, channelTitle: String) {
        self.isLoading = true
        callModel.startCall(user: user) { result in
            switch result {
            case .success(let channelId):
                self.callService.createCall(
                    channelId: channelId,
                    channelTitle: channelTitle,
                    user: user) { result in
                        switch result {
                        case .success(_):
                            self.channelId = channelId
                            self.callModel.initOutputRoute()
                            self.initialCallInfo(
                                channelId: self.channelId
                            )
                        case .failure(let error):
                            self.errorMessage = error.errorMessage
                            self.isErrorAlert = true
                        }
                    }
            case .failure(let error):
                self.errorMessage = error.errorMessage
                self.isErrorAlert = true
            }
        }
    }
    
    func initialCallInfo(channelId:String){
        self.callService
            .getUpdateCallById(channelId: channelId)
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
                if self.isFirstFetchCallInfo {
                    self.isLoading = false
                    self.isFirstFetchCallInfo = false
                } else {
                    self.callModel.stopBgm()
                }
            }
            .store(in: &self.cancellable)
    }
    
    // ホストが離脱(通話の終了)
    func finishChannel(
        callInfo:CallObservableModel,
        appState: AppState
    ){
        self.callModel.stopCall(
            userId: callInfo.call.hostUserId,
            channelId: self.channelId
        ) { result in
            switch result {
            case .success(_):
                self.callService.stopCall(channelId: self.channelId) { result in
                    switch result {
                    case .success(_):
                        self.isSuccessDeleteCall = true
                        RealTimeCallStatus.shared.initial()
                        appState.isHostCallReload = true
                    case .failure(let error):
                        self.errorMessage = error.errorMessage
                        self.isErrorAlert = true
                    }
                }
            case .failure(let error):
                self.errorMessage = error.errorMessage
                self.isErrorAlert = true
            }
        }
    }
    
    // ミュートする
    func muteAudio(){
        self.callModel.muteAudio(isMuted: self.isMuted) {
            self.isMuted.toggle()
        }
    }
    
    func changeOutputRoute() {
        self.callModel.changeOutputRoute(isSpeaker: self.isSpeaker) {
            self.isSpeaker.toggle()
        }
    }
    
    func updateAttendeeCallStatus(userId: String, channelId: String) {
        self.userService.updateUserCallingStatus(userId: userId) { result in
            switch result {
            case .success(_):
                self.callService
                    .leaveChannel(channelId: channelId, userId: userId)
                    .sink { completion in
                        switch completion {
                        case .finished:
                            print("successfully handle drop or leaveUser")
                        case .failure(let error):
                            self.errorMessage = error.errorMessage
                            self.isErrorAlert = true
                        }
                    } receiveValue: { _ in }
                    .store(in: &self.cancellable)
                
            case .failure(let error):
                self.errorMessage = error.errorMessage
                self.isErrorAlert = true
            }
        }
    }
}
