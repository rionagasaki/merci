//
//  ChatViewModel.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/01.
//

import SwiftUI
import Combine

class ChatViewModel: ObservableObject {
    @Published var messageText: String = ""
    @Published var chatRoomId: String = ""
    @Published var isErrorAlert: Bool = false
    @Published var errorMessage: String = ""
    @Published var isPairProfileModal: Bool = false
    @Published var isJoinCallModal: Bool = false
    @Published var trigger: Bool?
    @Published var chatList:[ChatObservableModel] = []
    @Published var scrollId: UUID = UUID()
    
    let setToFirestore = SetToFirestore()
    let fetchFromFirestore = FetchFromFirestore()
    
    private var cancellable = Set<AnyCancellable>()
    
    func fetchMessage() {
        fetchFromFirestore
            .snapshotOnChat(chatroomID: self.chatRoomId)
            .sink { completion in
                switch completion {
                case .finished:
                    print("ここは呼ばれない")
                case .failure(let error):
                    self.isErrorAlert = true
                    self.errorMessage = error.errorMessage
                }
            } receiveValue: { chat in
                self.chatList.append(.init(
                    message: chat.message,
                    createdAt: DateFormat.shared.timeFormat(date: chat.createdAt.dateValue()),
                    sendUserID: chat.sendUserID,
                    sendUserNickname: chat.sendUserNickname,
                    sendUserProfileImageURL: chat.sendUserProfileImageURL
                ))
            }
            .store(in: &self.cancellable)
    }
    
    func makeChatRoomAndSendMessage(userModel: UserObservableModel, pairModel: PairObservableModel, chatPair: PairObservableModel, appState: AppState){
        setToFirestore.makeChat(
            requestPairID: pairModel.pair.id,
            requestedPairID: chatPair.pair.id,
            message: messageText,
            sendUserInfo: userModel,
            currentPairUserID: appState.pairUserModel.user.uid,
            currentChatPairUserID_1: chatPair.pair.pair_1_uid,
            currentChatPairUserID_2: chatPair.pair.pair_2_uid,
            recieveNotificatonTokens: [
                chatPair.pair.pair_2_fcmToken,
                chatPair.pair.pair_1_fmcToken,
                appState.pairUserModel.user.fcmToken
            ],
            createdAt: Date()
        )
        .sink { completion in
            switch completion {
            case .finished:
                self.messageText = ""
                print("success make chatroom and send message!")
            case .failure(let error):
                self.messageText = ""
                self.isErrorAlert = true
                self.errorMessage = error.errorMessage
            }
        } receiveValue: { chatRoomId in
            self.chatRoomId = chatRoomId
        }
        .store(in: &self.cancellable)
    }
    
    func sendMessage(userModel: UserObservableModel, pairModel: PairObservableModel, chatPair: PairObservableModel, appState: AppState) {
        setToFirestore.sendMessage(
            chatRoomID: chatRoomId,
            currentUserPairID: pairModel.pair.id,
            chatPairID: chatPair.pair.id,
            currentPairUserID: appState.pairUserModel.user.uid,
            currentChatPairUserID_1: chatPair.pair.pair_1_uid,
            currentChatPairUserID_2: chatPair.pair.pair_2_uid,
            createdAt: Date(),
            message: messageText,
            user: userModel,
            recieveNotificatonTokens: [
                appState.pairUserModel.user.fcmToken,
                chatPair.pair.pair_1_fmcToken,
                chatPair.pair.pair_2_fcmToken
            ]
        )
        .sink { completion in
            switch completion {
            case .finished:
                self.messageText = ""
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
}


