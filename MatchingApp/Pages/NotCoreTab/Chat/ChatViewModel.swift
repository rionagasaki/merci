//
//  ChatViewModel.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/01.
//

import SwiftUI
import Combine

@MainActor
final class ChatViewModel: ObservableObject {
    
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
    @Published var isInitChat: Bool = true
    @Published var chatRoomId: String = ""
    @Published var channelId: String = ""
    
    @Published var isLastDocumentLoaded: Bool = false
    
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
    
    // handle error
    private func handleError(error: Error) {
        if let error = error as? AppError {
            self.errorMessage = error.errorMessage
        } else {
            self.errorMessage = error.localizedDescription
        }
        self.isErrorAlert = true
    }
    
    // 通話記録をリアルタイム監視する
    func monitorChatRoomData(chatRoomId: String, fromUser: UserObservableModel, toUserID: String){
        self.chatService
            .getUpdateChatRoomData(chatroomID: chatRoomId)
            .sink { completion in
                switch completion {
                case .finished:
                    break
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
    
    // here is message listener
    func monitorLatestMessage(chatRoomID: String) {
        self.chatService.getUpdateLatestMessageData(chatRoomID: chatRoomID)
            .sink { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    self.handleError(error: error)
                }
            } receiveValue: { [weak self] chat in
                guard let self = self else { return }
                self.allMessages.append(chat.adaptionChatData())
                withAnimation {
                    self.scrollID = UUID(uuidString: self.allMessages.last?.chatId ?? .init()) ?? .init()
                    self.messageText = ""
                }
                self.isInitChat = false
            }.store(in: &self.cancellable)
    }
    
    func getMessageData(user: UserObservableModel, chatRoomId: String) async {
        do {
            self.allMessages = []
            async let _ = chatService.updateMessageCountZero(readUser: user, chatRoomId: chatRoomId)
            async let getChats = self.chatService.getMessageData(chatroomID: chatRoomId)
            let chats = try await getChats
            
            self.allMessages = chats.map { $0.adaptionChatData() }.reversed()
            self.allMessages.removeLast()
            self.monitorLatestMessage(chatRoomID: chatRoomId)
        } catch {
            self.handleError(error: error)
        }
    }
    
    func getPreviousMessages(chatRoomID: String) async {
        do {
            self.isLoading = true
            let chats = try await self.chatService.getNextMessageData(chatroomID: chatRoomID)
            if chats.count < 20 {
                self.isLastDocumentLoaded = true
            }
            withAnimation {
                self.allMessages = chats.map { $0.adaptionChatData() } + self.allMessages
            }
            self.isLoading = false
        } catch {
            handleError(error: error)
        }
    }
    
    // 初回メッセージ時(メッセージルームを作成して、メッセージを送信する)
    func createChatRoomAndSendMessage(
        fromUser: UserObservableModel,
        toUser:UserObservableModel,
        appState: AppState
    ) async {
        do {
            let chatRoomID = try await self.chatService.createChatRoomAndSendMessage(
                message: self.messageText,
                fromUser: fromUser,
                toUser: toUser,
                createdAt: Date.init())
            self.chatRoomId = chatRoomID
            withAnimation {
                self.messageText = ""
            }
            self.monitorLatestMessage(chatRoomID: chatRoomID)
            
        } catch {
            self.handleError(error: error)
        }
    }
    
    // メッセージを送る
    func sendMessage(
        fromUser: UserObservableModel,
        toUser: UserObservableModel,
        appState: AppState
    ) async {
        do {
            try await self.chatService.sendMessage(
                chatRoomId: self.chatRoomId,
                fromUser: fromUser,
                toUser: toUser,
                createdAt: Date.init(),
                message: self.messageText
            )
        } catch {
            self.handleError(error: error)
        }
    }
    
    // 未読数を0にする
    func updateMessageUnReadCountZero(user:UserObservableModel) async {
        if self.chatRoomId.isEmpty { return }
        
        do {
            try await  self.chatService.updateMessageCountZero(readUser: user, chatRoomId: self.chatRoomId)
        } catch {
            self.handleError(error: error)
        }
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


