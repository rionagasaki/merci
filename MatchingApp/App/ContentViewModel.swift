//
//  ContentViewModel.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/07/02.
//

import SwiftUI
import Combine
import FirebaseAuth

class ContentViewModel: ObservableObject {
    @Published var isLoginModal: Bool = false
    @Published var isUserInfoSetupRequired: Bool = false
    @Published var isRequiredOnboarding: Bool = false

    @Published var isErrorAlert = false
    @Published var errorMessage: String = ""
    
    private let userService = UserFirestoreService()
    private let postService = PostFirestoreService()
    private let noticeService = NoticeFirestoreService()
    private var cancellable = Set<AnyCancellable>()
    private let UIIFGeneratorMedium = UIImpactFeedbackGenerator(style: .heavy)
    
    func initialUserInfo(user: FirebaseAuth.User, userModel: UserObservableModel, appState: AppState) {
        self.userService.getUpdateUser(uid: user.uid) { [weak self] result in
            guard let weakSelf = self else { return }
            switch result {
            case .success(let user):
                userModel.user = user
                if user.email.isEmpty || user.uid.isEmpty { return }
                
                if user.nickname.isEmpty {
                    weakSelf.isUserInfoSetupRequired = true
                    return
                }
                // オンボーディングを最後まで完了していない場合
                if !user.onboarding {
                    weakSelf.isRequiredOnboarding = true
                    return
                }
    
                // 未既読なチャットがある場合
                let unreadExceptHiddenUserIDs = Array<String>(user.chatmateMapping.keys).filter { !user.hiddenChatRoomUserIDs.contains($0) }
                let unreadChatRoomIDs = unreadExceptHiddenUserIDs.compactMap { userID in if let chatRoomID = user.chatmateMapping[userID] { return chatRoomID } else { return nil } }
                
                let allUnreadMessageCount =  unreadChatRoomIDs.compactMap { chatRoomID in
                    if let unreadCount = user.unreadMessageCount[chatRoomID] {
                        return unreadCount
                    } else {
                        return nil
                    }
                }.reduce(0) { partialResult, next in
                    return partialResult + next
                }
                
                if allUnreadMessageCount > 0 {
                    if !appState.tabWithNotice.contains(.message) {
                        weakSelf.UIIFGeneratorMedium.impactOccurred()
                        appState.tabWithNotice.append(.message)
                    } else {
                        if appState.unreadMessageAllCount < allUnreadMessageCount {
                            weakSelf.UIIFGeneratorMedium.impactOccurred()
                            appState.tabWithNotice = appState.tabWithNotice.filter { $0 != .message }
                            appState.tabWithNotice.append(.message)
                        }
                    }
                } else {
                    if appState.tabWithNotice.contains(.message) {
                        appState.tabWithNotice = appState.tabWithNotice.compactMap { message in
                            if message == .message {
                                return nil
                            } else {
                                return message
                            }
                        }
                    }
                }
                
                appState.unreadMessageAllCount = allUnreadMessageCount
                
                weakSelf.noticeService.getAllNotices(userID: user.uid)
                    .sink { completion in
                        switch completion {
                        case .finished:
                            print("successfully initialize")
                        case .failure(let error):
                            weakSelf.errorMessage = error.errorMessage
                            weakSelf.isErrorAlert = true
                        }
                    } receiveValue: { [weak self] (_, commentNotices, requestNotice) in
                        guard let weakSelf = self else { return }
                        weakSelf.confirmNotice(
                            appState: appState,
                            commentNotices: commentNotices,
                            followNotices: requestNotice
                        )
                    }
                    .store(in: &weakSelf.cancellable)

            case .failure(let error):
                weakSelf.errorMessage = error.errorMessage
                weakSelf.isErrorAlert = true
            }
        }
    }
    
    func resetChannelID(userID: String){
        self.userService.updateUserCallingStatus(userID: userID) { [weak self] result in
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
    
    func confirmNotice(appState: AppState, commentNotices: [CommentNoticeObservableModel], followNotices:[RequestNoticeObservableModel]){
        let commentNoticeReadStatus:[Bool] = commentNotices.map { $0.isRead }
        let followNoticeReadStatus:[Bool] = followNotices.map { $0.isRead }
        let allNoticesReadStatus:[Bool] = commentNoticeReadStatus + followNoticeReadStatus
        
        // 未既読の通知が存在する
        if allNoticesReadStatus.contains(false) {
            if !appState.tabWithNotice.contains(.notification) {
                appState.tabWithNotice.append(.notification)
            }
        } else {
            if appState.tabWithNotice.contains(.notification) {
                appState.tabWithNotice = appState.tabWithNotice.compactMap { notice in
                    if notice == .notification {
                        return nil
                    } else {
                        return notice
                    }
                }
            }
        }
    }
    
    func updateUserTokenAndInitialUserInfo(token: String){
        guard let user = AuthenticationManager.shared.user else { return }
        userService.updateUserInfo(currentUid: user.uid, key: "fcmToken", value: token)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                guard let weakSelf = self else { return }
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    weakSelf.isErrorAlert = true
                    weakSelf.errorMessage = error.errorMessage
                }
            } receiveValue: { _ in }
            .store(in: &self.cancellable)
    }
}
