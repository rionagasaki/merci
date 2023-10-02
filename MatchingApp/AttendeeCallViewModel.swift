//
//  AttendeeCallViewModel.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/08/19.
//

import Foundation
import Combine
import AmazonChimeSDK
import AVFoundation

class AttendeeCallViewModel: ObservableObject {
    
    enum AlertType {
        case leaveWarning
        case leaveHost
        case connectionFatalWarning
    }
    
    private var cancellable = Set<AnyCancellable>()
    private let callService = CallFirestoreService()
    private let userService = UserFirestoreService()
    private let callModel = CallModel(isGroupCall: true)
    private let realTimeCallStatus = RealTimeCallStatus.shared
    
    @Published var isLoading: Bool = false
    @Published var channelId: String = ""
    @Published var call:CallObservableModel?
    @Published var isFinishedCall: Bool = false
    @Published var isMuted: Bool = false
    @Published var isSpeaker: Bool = false
    @Published var alertType: AlertType = .leaveWarning
    @Published var isAlert: Bool = false
    @Published var isErrorAlert: Bool = false
    @Published var errorMessage: String = ""
    
    
    func joinCall(
        channelId: String,
        userModel: UserObservableModel
    ) {
        self.isLoading = true
        self.callModel.joinCall(user: userModel, channelId: channelId) { [weak self] result in
            guard let weakSelf = self else { return }
            switch result {
            case .success(_):
                weakSelf.joinCallToFirestore(channelId: channelId, userModel: userModel)
            case .failure(let error):
                weakSelf.errorMessage = error.errorMessage
                weakSelf.isErrorAlert = true
            }
        }
    }

    func joinCallToFirestore(channelId: String, userModel: UserObservableModel){
        self.callService.joinCall(channelId: channelId, user: userModel) { [weak self] result in
            guard let weakSelf = self else { return }
            switch result {
            case .success(_):
                weakSelf.callModel.initOutputRoute()
                weakSelf.channelId = channelId
                weakSelf.realTimeCallStatus.channelId = channelId
                weakSelf.initialCallInfo(channelId: channelId, userId: userModel.user.uid)
            case .failure(let error):
                weakSelf.errorMessage = error.errorMessage
                weakSelf.isErrorAlert = true
            }
        }
    }
    
    func initialCallInfo(channelId:String, userId: String){
        self.callService
            .getUpdateCallById(channelId: channelId)
            .sink { [weak self] completion in
                guard let weakSelf = self else { return }
                switch completion {
                case .finished:
                    print("successfully fetch call data")
                case .failure(_):
                    weakSelf.alertType = .connectionFatalWarning
                    weakSelf.isAlert = true
                }
            } receiveValue: { [weak self] call in
                guard let weakSelf = self else { return }
                weakSelf.call = call
                weakSelf.isLoading = false
                weakSelf.realTimeCallStatus.callingUser = Array<String>(call.call.userIdToUserIconImageUrlString.keys)
                if !call.call.callingNow {
                    weakSelf.isFinishedCall = true
                }
            }
            .store(in: &self.cancellable)
    }
    
    func muteAudio(){
        self.callModel.muteAudio(isMuted: self.isMuted) {
            self.isMuted.toggle()
        }
    }
    
    func changeOutputRouter() {
        self.callModel.changeOutputRoute(isSpeaker: self.isSpeaker) {
            self.isSpeaker.toggle()
        }
    }
    
    func leaveChannelAndUpdateAttendeeCallStatus(userID: String, channelID: String) {
        self.callModel.leaveCall()
        self.callService.leaveChannel(channelId: channelID, userId: userID)
            .sink { [weak self] completion in
                guard let weakSelf = self else { return }
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    weakSelf.errorMessage = error.errorMessage
                    weakSelf.isErrorAlert = true
                }
            } receiveValue: { _ in }
            .store(in: &self.cancellable)
    }
    
    func finishChannel(callInfo: CallObservableModel){
        self.callModel.stopCall(
            userId: callInfo.call.hostUserId,
            channelId: self.channelId
        ) { [weak self] result in
            guard let weakSelf = self else { return }
            switch result {
            case .success(_):
                break
            case .failure(let error):
                weakSelf.errorMessage = error.errorMessage
                weakSelf.isErrorAlert = true
            }
        }
    }
}
