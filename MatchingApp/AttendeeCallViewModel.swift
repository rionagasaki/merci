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
    private let callModel = CallModel()
    
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
        self.callModel.joinCall(user: userModel, channelId: channelId) { result in
            switch result {
            case .success(_):
                self.callService.joinCall(channelId: channelId, user: userModel) { result in
                    switch result {
                    case .success(_):
                        self.callModel.initOutputRoute()
                        self.channelId = channelId
                        self.initialCallInfo(channelId: channelId, userId: userModel.user.uid)
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
    
    func initialCallInfo(channelId:String, userId: String){
        self.callService
            .getUpdateCallById(channelId: channelId)
            .sink { completion in
                switch completion {
                case .finished:
                    print("successfully fetch call data")
                case .failure(_):
                    self.alertType = .connectionFatalWarning
                    self.isAlert = true
                }
            } receiveValue: { call in
                self.call = call
                self.isLoading = false
                
                if !call.call.callingNow {
                    self.userService.updateUserCallingStatus(userId: userId) { result in
                        switch result {
                        case .success(_):
                            self.isFinishedCall = true
                        case .failure(let error):
                            self.errorMessage = error.errorMessage
                            self.isErrorAlert = true
                        }
                    }
                }
            }
            .store(in: &self.cancellable)
    }
    
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
    
    func leaveChannelAndUpdateAttendeeCallStatus(userId: String, channelId: String) {
        self.callModel.leaveCall()
        self.userService.updateUserCallingStatus(userId: userId) { result in
            switch result {
            case .success(_):
                self.callService.leaveChannel(channelId: channelId, userId: userId)
                    .sink { completion in
                        switch completion {
                        case .finished:
                            print("successfully handle drop or leaveUser")
                            RealTimeCallStatus.shared.initial()
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
