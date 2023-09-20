//
//  IndividualAttendeeCallViewModel.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/08/30.
//

import Foundation
import AmazonChimeSDK
import AVFoundation
import Combine

class IndividualAttendeeCallViewModel: ObservableObject {

    enum AlertType {
        case leaveWarning
        case connectionFatalWarning
    }
    
    @Published var isLoading: Bool = false
    @Published var isMuted: Bool = false
    @Published var isSpeaker: Bool = false
    @Published var isErrorAlert: Bool = false
    @Published var errorMessage: String = ""
    @Published var isSuccessCallLeave: Bool = false
    @Published var isAlert: Bool = false
    @Published var alertType: AlertType = .leaveWarning
    
    private var cancellable = Set<AnyCancellable>()
    private let callService = CallFirestoreService()
    private let chatService = ChatFirestoreService()
    private let userService = UserFirestoreService()
    private let callModel = CallModel()
    
    func joinCall(channelId: String, chatRoomID: String, userModel: UserObservableModel) {
        self.isLoading = true
        self.callModel.joinCall(user: userModel, channelId: channelId) { result in
            switch result {
            case .success(_):
                self.chatService.joinOneToOneCall(
                    chatRoomId: chatRoomID,
                    user: userModel) { result in
                        switch result {
                        case .success(_):
                            self.callModel.initOutputRoute()
                            self.initialCallInfo(
                                chatRoomID: chatRoomID,
                                userId: userModel.user.uid
                            )
                        case .failure(let error):
                            self.isErrorAlert = true
                            self.errorMessage = error.errorMessage
                        }
                    }
                
            case .failure(let error):
                self.errorMessage = error.errorMessage
                self.isErrorAlert = true
            }
        }
    }
    
    func initialCallInfo(chatRoomID: String, userId: String){
        self.chatService
            .getChatRoomData(chatroomID: chatRoomID)
            .sink { completion in
                switch completion {
                case .finished:
                    print("success initial callInfo")
                case .failure(let error):
                    self.errorMessage = error.errorMessage
                    self.isErrorAlert = true
                }
            } receiveValue: { chatRoomData in
                self.isLoading = false
                if chatRoomData.channelId.isEmpty {
                    self.userService.updateUserCallingStatus(userId: userId) { result in
                        switch result {
                        case .success(_):
                            self.isSuccessCallLeave = true
                            FirestoreListener.shared.chatListener?.remove()
                        case .failure(let error):
                            self.errorMessage = error.errorMessage
                            self.isErrorAlert = true
                        }
                    }
                }
            }
            .store(in: &self.cancellable)
    }
    
    func muteAudio() {
        callModel.muteAudio(isMuted: self.isMuted) {
            self.isMuted.toggle()
        }
    }
    
    func changeOutputRouter() {
        self.callModel.changeOutputRoute(isSpeaker: self.isSpeaker) {
            self.isSpeaker.toggle()
        }
    }
    
    func stopChannel(userId: String, chatRoomId: String,channelId: String) {
        self.callModel.stopCall(
            userId: userId,
            channelId: channelId
        ) { result in
                switch result {
                case .success(_):
                    self.chatService.stopOneToOneCall(chatRoomId: chatRoomId) { result in
                        switch result {
                        case .success(_):
                            self.isSuccessCallLeave = true
                        case .failure(let error):
                            self.isErrorAlert = true
                            self.errorMessage = error.errorMessage
                        }
                    }
                case .failure(let error):
                    self.isErrorAlert = true
                    self.errorMessage = error.errorMessage
                }
            }
    }
}
