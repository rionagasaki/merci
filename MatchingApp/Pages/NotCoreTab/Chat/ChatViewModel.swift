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
    
    @Published var messageText: String = ""
    @Published var textFieldHeight: CGFloat = 40
    @Published var newlineCount: Int = 0
    @Published var chatRoomId: String = ""
    @Published var messageId: String = ""
    @Published var channelId: String = ""
    @Published var channelTitle: String = ""
    @Published var talkUserNickName: String = ""
    @Published var isErrorAlert: Bool = false
    @Published var errorMessage: String = ""
    @Published var isPairProfileModal: Bool = false
    @Published var isCreateCallActionSheet: Bool = false
    @Published var isCreateCall: Bool = false
    @Published var isJoinCall: Bool = false
    @Published var trigger: Bool?
    @Published var allMessages:[ChatObservableModel] = []
    @Published var requestedCallNoticeOffSet: CGFloat = 250
    @Published var isRequiredAddFriend: Bool = false
    @Published var scrollId: UUID = UUID()
    
    let chatService = ChatFirestoreService()
    private let functions: CloudFunctions
    private var cancellable = Set<AnyCancellable>()
    
    init(functions: CloudFunctions = CloudFunctions.init()){
        self.functions = functions
    }
    
    func initial(user: UserObservableModel, chatRoomId: String) {
        self.chatService
            .updateMessageCountZero(readUser: user, chatRoomId: chatRoomId)
            .flatMap { _ in
                return self.chatService.getUpdateChat(chatroomID: self.chatRoomId)
            }
            .sink { completion in
                switch completion {
                case .finished:
                    print("ここは呼ばれない")
                case .failure(let error):
                    self.isErrorAlert = true
                    self.errorMessage = error.errorMessage
                }
            } receiveValue: { chat in
                self.scrollId = UUID(uuidString: chat.chatId) ?? .init()
                self.allMessages.append(.init(
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
    
    func initialChatRoom(chatRoomId: String){
        self.chatService.getChatRoomData(chatroomID: chatRoomId)
            .sink { completion in
                switch completion {
                case .finished:
                    print("ここは呼ばれない")
                case .failure(let error):
                    self.isErrorAlert = true
                    self.errorMessage = error.errorMessage
                }
            } receiveValue: { chatRoomData in
                withAnimation {
                    self.channelId = chatRoomData.channelId
                }
            }
            .store(in: &self.cancellable)
    }
    
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
        .flatMap { chatRoomId -> AnyPublisher<Chat, AppError> in
            self.chatRoomId = chatRoomId
            return self.chatService.getUpdateChat(chatroomID: chatRoomId)
        }
        .sink { completion in
            switch completion {
            case .finished:
                print("success make chatroom and send message!")
            case .failure(let error):
                self.messageText = ""
                self.isErrorAlert = true
                self.errorMessage = error.errorMessage
            }
        } receiveValue: { chat in
            self.allMessages.append(.init(
                chatId: chat.chatId,
                message: chat.message,
                createdAt: DateFormat.timeFormat(date: chat.createdAt.dateValue()),
                fromUserUid: chat.fromUserUid,
                fromUserNickname: chat.fromUserNickname,
                fromUserProfileImageUrl: chat.fromUserProfileImageUrl,
                toUserToken: chat.toUserToken
            ))
            withAnimation {
                self.messageText = ""
                self.newlineCount = 0
                self.textFieldHeight = 40
            }
        }
        .store(in: &self.cancellable)
    }
    
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
        .sink { completion in
            switch completion {
            case .finished:
                withAnimation {
                    self.messageText = ""
                    self.newlineCount = 0
                    self.textFieldHeight = 40
                }
                print("success message send!")
            case .failure(let error):
                self.messageText = ""
                self.isErrorAlert = true
                self.errorMessage = error.errorMessage
            }
        } receiveValue: { _ in
            print("recieve value")
        }
        .store(in: &self.cancellable)
    }
    
    func updateMessageUnReadCountZero(user:UserObservableModel){
        if self.chatRoomId.isEmpty { return }
        self.chatService.updateMessageCountZero(readUser: user, chatRoomId: self.chatRoomId)
            .sink { completion in
                switch completion {
                case .finished:
                    print("success message send!")
                case .failure(let error):
                    print("failure: \(error)")
                }
            } receiveValue: { _ in
                print("recieve value")
            }
            .store(in: &self.cancellable)
    }
}


