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
    private var musicData: Data {
        guard let music = NSDataAsset(name: "Calling") else {
            return Data.init()
        }
        return music.data
    }
    private let callModel = CallModel(isGroupCall: true)
    private let realTimeCallStatus = RealTimeCallStatus.shared
    // 通話ホストの場合、最初はCallObservableObjectは存在しないので、channelIdが必要。
    var musicPlayer:AVAudioPlayer?
    @Published var channelId: String = ""
    @Published var isFirstFetchCallInfo: Bool = true
    @Published var call: CallObservableModel?
    @Published var isLoading: Bool = false
    @Published var isStopLoading: Bool = false
    @Published var isBgm: Bool = false
    @Published var isMuted: Bool = false
    @Published var isSpeaker: Bool = false
    @Published var isAlertDeleteCall: Bool = false
    @Published var isSuccessDeleteCall: Bool = false
    @Published var isErrorAlert: Bool = false
    @Published var errorMessage: String = ""
    
    func startCalling(user: UserObservableModel, channelTitle: String) {
        self.isLoading = true
        callModel.startCall(user: user) { [weak self] result in
            guard let weakSelf = self else { return }
            switch result {
            case .success(let channelId):
                weakSelf.createCallToFirestore(
                    channelId: channelId,
                    channelTitle: channelTitle,
                    user: user
                )
            case .failure(let error):
                weakSelf.errorMessage = error.errorMessage
                weakSelf.isErrorAlert = true
            }
        }
    }
    
    func createCallToFirestore(channelId: String, channelTitle: String, user: UserObservableModel) {
        self.callService.createCall(
            channelId: channelId,
            channelTitle: channelTitle,
            user: user) { [weak self] result in
                guard let weakSelf = self else { return }
                switch result {
                case .success(_):
                    weakSelf.channelId = channelId
                    weakSelf.callModel.initOutputRoute()
                    weakSelf.realTimeCallStatus.channelId = channelId
                    weakSelf.realTimeCallStatus.isHostUid = user.user.uid
                    weakSelf.initialCallInfo(channelId: weakSelf.channelId)
                case .failure(let error):
                    weakSelf.errorMessage = error.errorMessage
                    weakSelf.isErrorAlert = true
                }
            }
    }
    
    func initialCallInfo(channelId:String){
        self.callService
            .getUpdateCallById(channelId: channelId)
            .sink { [weak self] completion in
                guard let weakSelf = self else { return }
                switch completion {
                case .finished:
                    print("successfully fetch call data")
                case .failure(let error):
                    weakSelf.isErrorAlert = true
                    weakSelf.errorMessage = error.errorMessage
                }
            } receiveValue: { [weak self] call in
                guard let weakSelf = self else { return }
                weakSelf.call = call
                weakSelf.realTimeCallStatus.callingUser = Array<String>(call.call.userIdToUserIconImageUrlString.keys)
                if weakSelf.isFirstFetchCallInfo {
                    weakSelf.isLoading = false
                    weakSelf.isFirstFetchCallInfo = false
                } else {
                    weakSelf.callModel.stopBgm()
                }
            }
            .store(in: &self.cancellable)
    }
    
    // ホストが離脱(通話の終了)
    func finishChannel(
        callInfo:CallObservableModel,
        appState: AppState
    ) {
        self.isStopLoading = true
        self.callModel.stopCall(
            userId: callInfo.call.hostUserId,
            channelId: self.channelId
        ) { [weak self] result in
            guard let weakSelf = self else { return }
            switch result {
            case .success(_):
                weakSelf.isSuccessDeleteCall = true
                appState.isHostCallReload = true
                weakSelf.realTimeCallStatus.isHostUid = ""
                weakSelf.isStopLoading = false
            case .failure(let error):
                weakSelf.errorMessage = error.errorMessage
                weakSelf.isErrorAlert = true
            }
        }
    }
    
    func muteAudio(){
        self.callModel.muteAudio(isMuted: self.isMuted) {
            self.isMuted.toggle()
        }
    }
    
    func changeOutputRoute() {
        self.callModel.changeOutputRoute(isSpeaker: self.isSpeaker) { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.isSpeaker.toggle()
        }
    }
    
    func updateAttendeeCallStatus(userId: String, channelId: String) {
        self.userService.updateUserCallingStatus(userID: userId){ [weak self] result in
            guard let weakSelf = self else { return }
            switch result {
            case .success(_):
                weakSelf.callService
                    .leaveChannel(channelId: channelId, userId: userId)
                    .sink { [weak self] completion in
                        guard let weakSelf = self else { return }
                        switch completion {
                        case .finished:
                            weakSelf.realTimeCallStatus.callingUser = weakSelf.realTimeCallStatus.callingUser.filter { $0 != userId }
                        case .failure(let error):
                            weakSelf.errorMessage = error.errorMessage
                            weakSelf.isErrorAlert = true
                        }
                    } receiveValue: { _ in }
                    .store(in: &weakSelf.cancellable)
                
            case .failure(let error):
                weakSelf.errorMessage = error.errorMessage
                weakSelf.isErrorAlert = true
            }
        }
    }
}
