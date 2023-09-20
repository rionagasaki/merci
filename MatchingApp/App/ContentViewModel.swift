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
    @Published var isRequiredOnboarding: Bool = false
    @Published var isUserInfoSetupRequired: Bool = false

    @Published var searchWord = ""
    @Published var isErrorAlert = false
    @Published var errorMessage: String = ""
    @Published var isPairSetUpRequired = false
    @AppStorage("isFirstLaunch") var isFirstLaunch: Bool = true
    
    private let userService = UserFirestoreService()
    private let postService = PostFirestoreService()
    private let noticeService = NoticeFirestoreService()
    private var cancellable = Set<AnyCancellable>()
    private let UIIFGeneratorMedium = UIImpactFeedbackGenerator(style: .heavy)
    
    func resetUserInfo(userModel: UserObservableModel, appState: AppState){
        AuthenticationService.shared.signOut()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("successfully logout")
                    userModel.initial()
                    self.isFirstLaunch = false
                case let .failure(error):
                    print("Error",error)
                }
            }, receiveValue: { _ in
                print("Recieve Value!")
            })
            .store(in: &cancellable)
    }
    
    func initialUserInfo(user: FirebaseAuth.User, userModel: UserObservableModel, appState: AppState) {
        self.userService.getUpdateUser(uid: user.uid) { result in
            switch result {
            case .success(let user):
                userModel.user = user
                if user.email.isEmpty || user.uid.isEmpty { return }
                
                if user.nickname.isEmpty {
                    self.isUserInfoSetupRequired = true
                    return
                }
                // オンボーディングを最後まで完了していない場合
                if !user.onboarding {
                    self.isRequiredOnboarding = true
                    return
                }
                // 未既読なチャットがある場合
                let allUnreadMessageCount =  user.unreadMessageCount.values.reduce(0) { partialResult, next in
                    return partialResult + next
                }
                if user.unreadMessageCount.values.contains(where: { $0 > 0 }) {
                    if !appState.tabWithNotice.contains(.message) {
                        self.UIIFGeneratorMedium.impactOccurred()
                        appState.tabWithNotice.append(.message)
                    } else {
                        if appState.unreadMessageAllCount < allUnreadMessageCount {
                            self.UIIFGeneratorMedium.impactOccurred()
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
                
                self.noticeService.getAllNotices(userID: user.uid)
                    .sink { completion in
                        switch completion {
                        case .finished:
                            print("successfully initialize")
                        case .failure(let error):
                            self.errorMessage = error.errorMessage
                            self.isErrorAlert = true
                        }
                    } receiveValue: { (_, commentNotices, requestNotice) in
                        self.confirmNotice(
                            appState: appState,
                            commentNotices: commentNotices,
                            followNotices: requestNotice
                        )
                    }
                    .store(in: &self.cancellable)

            case .failure(let error):
                self.errorMessage = error.errorMessage
                self.isErrorAlert = true
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
            .sink { completion in
                switch completion {
                case .finished:
                    print("token successfully update")
                case .failure(let error):
                    self.isErrorAlert = true
                    self.errorMessage = error.errorMessage
                }
            } receiveValue: { _ in
                print("recieve value")
            }
            .store(in: &self.cancellable)
    }
}
