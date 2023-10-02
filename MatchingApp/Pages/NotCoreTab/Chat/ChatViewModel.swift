//
//  ChatViewModel.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/01.
//

import SwiftUI
import Combine

class ChatViewModel: ObservableObject {
    
    enum AlertType {
        case isRequiredAddFriend
        case isCallingNow
    }
    
    enum CallingStats {
        case noCall
        case calling
        case createCallRoom
        case deadCall
        case waitingUser
        case waitedUser
    }
    @Published var isLoading: Bool = false
    @Published var callingStatus: CallingStats = .noCall
    @Published var messageText: String = ""
    
    @Published var chatRoomId: String = ""
    @Published var channelId: String = ""
    
    @Published var isErrorAlert: Bool = false
    @Published var errorMessage: String = ""
    @Published var isCreateCallActionSheet: Bool = false
    
    @Published var allMessages:[ChatObservableModel] = []
    @Published var requestedCallNoticeOffSet: CGFloat = 250
    
    @Published var scrollID: UUID = UUID()
    @Published var isMuted: Bool = false
    @Published var isSpeaker: Bool = false
    
    @Published var toUserCallingChannelId: String = ""
    
    private let functions: CloudFunctions
    private var cancellable = Set<AnyCancellable>()
    private let callService = CallFirestoreService()
    private let chatService = ChatFirestoreService()
    private let userService = UserFirestoreService()
    private let callModel = CallModel(isGroupCall: false)
    init(functions: CloudFunctions = CloudFunctions.init()){
        self.functions = functions
    }
    
    // 通話記録をリアルタイム監視する
    func monitorChatRoomData(chatRoomId: String, fromUser: UserObservableModel, toUserID: String){
        self.chatService
            .getUpdateChatRoomData(chatroomID: chatRoomId)
            .sink { completion in
                switch completion {
                case .finished:
                    print("ここは呼ばれない")
                case .failure(let error):
                    self.isErrorAlert = true
                    self.errorMessage = error.errorMessage
                }
            } receiveValue: { [weak self] chatRoomData in
                guard let weakSelf = self else { return }
                withAnimation {
                    weakSelf.channelId = chatRoomData.channelId

                    // 通話中のchannelIDが存在するかつ、そこに自分が存在していない
                    if !weakSelf.channelId.isEmpty && !chatRoomData.callingMate.contains(fromUser.user.uid) {
                        weakSelf.callingStatus = .waitedUser
                    }
                    // 通話中のchannelIDが存在するかつ、そこに相手が存在していない
                    else if !weakSelf.channelId.isEmpty && !chatRoomData.callingMate.contains(toUserID) {
                        weakSelf.callingStatus = .waitingUser
                    }
                    // 通話中
                    else if !weakSelf.channelId.isEmpty && chatRoomData.callingMate.contains(fromUser.user.uid) && chatRoomData.callingMate.contains(toUserID) {
                        weakSelf.callModel.stopBgm()
                        weakSelf.callingStatus = .calling
                    }
                    // 通話中でない
                    else if weakSelf.channelId.isEmpty && chatRoomData.callingMate == [] {
                        weakSelf.callingStatus = .noCall
                        weakSelf.callModel.leaveCall()
                    }
                }
            }
            .store(in: &self.cancellable)
    }
    
    func deadCallBar(fromUser: UserObservableModel){
        if fromUser.user.isCallingChannelId.isEmpty {
            withAnimation {
                self.callingStatus = .deadCall
            }
        }
    }
    
    // メッセージをリアルタイム監視する
    func monitorMessageData(user: UserObservableModel, chatRoomId: String) {
        self.chatService
            .updateMessageCountZero(readUser: user, chatRoomId: chatRoomId)
            .flatMap { [weak self] _ in
                guard let weakSelf = self else {
                    return Empty<Chat, AppError>().eraseToAnyPublisher()
                    
                }
                return weakSelf.chatService.getUpdateMessageData(
                    chatroomID: weakSelf.chatRoomId
                )
            }
            .sink { completion in
                switch completion {
                case .finished:
                    print("ここは呼ばれない")
                case .failure(let error):
                    self.isErrorAlert = true
                    self.errorMessage = error.errorMessage
                }
            } receiveValue: { [weak self] chat in
                guard let weakSelf = self else { return }
                weakSelf.scrollID = UUID(uuidString: chat.chatId) ?? .init()
                weakSelf.allMessages.append(.init(
                    chatId: chat.chatId,
                    message: chat.message,
                    createdAt: DateFormat.timeFormat(date: chat.createdAt.dateValue()),
                    fromUserUid: chat.fromUserUid,
                    fromUserNickname: chat.fromUserNickname,
                    fromUserProfileImageUrl: chat.fromUserProfileImageUrl,
                    toUserToken: chat.toUserToken
                ))
            }
            .store(in: &self.cancellable)
    }
    
    // 初回メッセージ時(メッセージルームを作成して、メッセージを送信する)
    func createChatRoomAndSendMessage(
        fromUser: UserObservableModel,
        toUser:UserObservableModel,
        appState: AppState
    ){
        self.chatService.createChatRoomAndSendMessage(
            message: self.messageText,
            fromUser: fromUser,
            toUser: toUser,
            createdAt: Date.init())
        .flatMap { [weak self] chatRoomId -> AnyPublisher<Chat, AppError> in
            guard let weakSelf = self else {
                return Empty<Chat, AppError>().eraseToAnyPublisher()
            }
            weakSelf.chatRoomId = chatRoomId
            return weakSelf.chatService.getUpdateMessageData(chatroomID: chatRoomId)
        }
        .sink { [weak self] completion in
            guard let weakSelf = self else { return }
            switch completion {
            case .finished:
                print("success make chatroom and send message!")
            case .failure(let error):
                weakSelf.messageText = ""
                weakSelf.isErrorAlert = true
                weakSelf.errorMessage = error.errorMessage
            }
        } receiveValue: { [weak self] chat in
            guard let weakSelf = self else { return }
            weakSelf.allMessages.append(.init(
                chatId: chat.chatId,
                message: chat.message,
                createdAt: DateFormat.timeFormat(date: chat.createdAt.dateValue()),
                fromUserUid: chat.fromUserUid,
                fromUserNickname: chat.fromUserNickname,
                fromUserProfileImageUrl: chat.fromUserProfileImageUrl,
                toUserToken: chat.toUserToken
            ))
            withAnimation {
                weakSelf.messageText = ""
            }
        }
        .store(in: &self.cancellable)
    }
    
    // メッセージを送る
    func sendMessage(
        fromUser: UserObservableModel,
        toUser: UserObservableModel,
        appState: AppState
    ) {
        chatService.sendMessage(
            chatRoomId: self.chatRoomId,
            fromUser: fromUser,
            toUser: toUser,
            createdAt: Date.init(),
            message: self.messageText
        )
        .sink { [weak self] completion in
            guard let weakSelf = self else { return }
            switch completion {
            case .finished:
                withAnimation {
                    weakSelf.messageText = ""
                }
            case .failure(let error):
                weakSelf.messageText = ""
                weakSelf.isErrorAlert = true
                weakSelf.errorMessage = error.errorMessage
            }
        } receiveValue: { _ in }
        .store(in: &self.cancellable)
    }
    
    // 未読数を0にする
    func updateMessageUnReadCountZero(user:UserObservableModel){
        if self.chatRoomId.isEmpty { return }
        self.chatService.updateMessageCountZero(readUser: user, chatRoomId: self.chatRoomId)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("failure: \(error)")
                }
            } receiveValue: { _ in }.store(in: &self.cancellable)
    }
    
    // 発信する
    func createOneToOneChannel(
        chatRoomId: String,
        fromUser: UserObservableModel,
        toUser: UserObservableModel
    ) {
        self.callingStatus = .createCallRoom
        self.callModel.startCall(user: fromUser){ [weak self] result in
            guard let weakSelf = self else { return }
            switch result {
            case .success(let channelId):
                weakSelf.callModel.initOutputRoute()
                weakSelf.createChannelToFirestore(
                    chatRoomId: chatRoomId,
                    channelId: channelId,
                    fromUser: fromUser,
                    toUser: toUser
                )
            case .failure(let error):
                weakSelf.errorMessage = error.errorMessage
                weakSelf.isErrorAlert = true
            }
        }
    }
    
    // 通話に参加する
    func joinCall(channelID: String, chatRoomID: String, userModel: UserObservableModel) {
        self.isLoading = true
        self.callModel.joinCall(
            user: userModel,
            channelId: channelID
        ) { [weak self] result in
            guard let weakSelf = self else { return }
            switch result {
            case .success(_):
                weakSelf.callModel.initOutputRoute()
                weakSelf.updateCallingMateToFirestore(chatRoomId: chatRoomID, channelId: channelID, user: userModel)
            case .failure(let error):
                weakSelf.errorMessage = error.errorMessage
                weakSelf.isErrorAlert = true
            }
        }
    }
    
    // firestoreに通話情報を登録する
    func createChannelToFirestore(
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
        .sink { [weak self] completion in
            guard let weakSelf = self else { return }
            switch completion {
            case .finished:
                break
            case .failure(let error):
                weakSelf.isErrorAlert = true
                weakSelf.errorMessage = error.errorMessage
            }
        } receiveValue: { _ in }.store(in: &self.cancellable)
    }
    
    func updateCallingMateToFirestore(
        chatRoomId: String,
        channelId: String,
        user: UserObservableModel
    ) {
        self.chatService.joinOneToOneCall(
            chatRoomId: chatRoomId,
            channelId: channelId,
            user: user
        ) { result in
                switch result {
                case .success(_):
                    self.isLoading = false
                    break
                case .failure(let error):
                    self.errorMessage = error.errorMessage
                    self.isErrorAlert = true
                }
            }
    }
    
    // ミュートする
    func muteAudio() {
        callModel.muteAudio(isMuted: self.isMuted) {
            self.isMuted.toggle()
        }
    }
    
    // マイクを管理する
    func changeOutputRouter() {
        self.callModel.changeOutputRoute(isSpeaker: self.isSpeaker) {
            self.isSpeaker.toggle()
        }
    }
    
    // 通話をやめる
    func stopChannel(
        fromUserID: String,
        toUserID: String
    ) {
        self.isLoading = true
        self.callModel.stopCall(
            userId: fromUserID,
            channelId: self.channelId
        ) { [weak self] result in
            guard let weakSelf = self else { return }
                switch result {
                case .success(_):
                    weakSelf.stopChannelInfoFromFirestore(fromUserID: fromUserID, toUserID: toUserID)
                case .failure(let error):
                    weakSelf.isErrorAlert = true
                    weakSelf.errorMessage = error.errorMessage
                }
            }
    }
    
    func stopChannelInfoFromFirestore(fromUserID: String, toUserID: String) {
        self.chatService.stopOneToOneCall(chatRoomId: self.chatRoomId, fromUserID: fromUserID, toUserID: toUserID) { [weak self] result in
            guard let weakSelf = self else { return }
            defer { RealTimeCallStatus.shared.initial()
                    weakSelf.isLoading = false
            }
            switch result {
            case .success(_):
                weakSelf.toUserCallingChannelId = ""
            case .failure(let error):
                weakSelf.isErrorAlert = true
                weakSelf.errorMessage = error.errorMessage
            }
        }
    }
}


