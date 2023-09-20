//
//  IndividualHostCallViewModel.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/08/30.
//

import Foundation
import AmazonChimeSDK
import AVFoundation
import Combine

class IndividualHostCallViewModel: ObservableObject {
    
    enum AlertType {
        case leaveWarning
        case connectionFatalWarning
    }
    
    @Published var isLoading: Bool = false
    @Published var channelId: String = ""
    @Published var isWaitingText: String = ""
    @Published var isMuted: Bool = false
    @Published var isSpeaker: Bool = false
    @Published var isAlertDeleteCall: Bool = false
    @Published var isSuccessCallLeave: Bool = false
    @Published var isErrorAlert: Bool = false
    @Published var errorMessage: String = ""
    @Published var isAlert: Bool = false
    @Published var alertType: AlertType = .leaveWarning
    
    private var cancellable = Set<AnyCancellable>()
    private let chatService = ChatFirestoreService()
    private let userService = UserFirestoreService()
    private let callModel = CallModel()
    
    func createOneToOneChannel(
        chatRoomId: String,
        fromUser: UserObservableModel,
        toUser: UserObservableModel
    ) {
        self.isLoading = true
        self.callModel.startCall(user: fromUser){ result in
            switch result {
            case .success(let channelId):
                self.channelId = channelId
                self.callModel.initOutputRoute()
                self.registerOneToOneCall(
                    chatRoomId: chatRoomId,
                    channelId: channelId,
                    fromUser: fromUser,
                    toUser: toUser
                )
            case .failure(let error):
                self.errorMessage = error.errorMessage
                self.isErrorAlert = true
            }
        }
    }
    
    func registerOneToOneCall(
        chatRoomId: String,
        channelId: String,
        fromUser:UserObservableModel,
        toUser: UserObservableModel
    ) {
        self.chatService.createOneToOneCall(
            chatRoomId: chatRoomId,
            channelId: channelId,
            fromUser: fromUser,
            toUser: toUser
        )
        .sink { completion in
            switch completion {
            case .finished:
                self.isLoading = false
                self.initialCallInfo(
                    chatRoomID: chatRoomId,
                    userId: fromUser.user.uid
                )
            case .failure(let error):
                self.isErrorAlert = true
                self.errorMessage = error.errorMessage
            }
        } receiveValue: { _ in
            print("recieve value")
        }
        .store(in: &self.cancellable)
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
                if chatRoomData.callingMate.count == 1 {
                    self.isWaitingText = "相手のユーザーが参加するのを待っています..."
                } else if chatRoomData.callingMate.count == 2 {
                    self.callModel.stopBgm()
                    self.isWaitingText = ""
                } else {
                    // 念の為
                    self.isWaitingText = ""
                }
                
                if chatRoomData.channelId.isEmpty {
                    self.isSuccessCallLeave = true
                    FirestoreListener.shared.chatListener?.remove()
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
    
    func stopChannel(
        userId: String,
        chatRoomId: String
    ) {
        self.callModel.stopCall(
            userId: userId,
            channelId: self.channelId
        ) { result in
                switch result {
                case .success(_):
                    self.chatService.stopOneToOneCall(
                        chatRoomId: chatRoomId
                    ) { result in
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
