//
//  NotificationListViewModel.swift
//  MovieShare
//
//  Created by Rio Nagasaki on 2023/07/27.
//

import Foundation
import Combine

@MainActor
final class NotificationListViewModel: ObservableObject {
    enum  NoticeType: String, CaseIterable {
        case good = "いいね"
        case comment = "コメント"
        case friend = "フレンド"
    }
    
    let noticeSections:[NoticeType]  = NoticeType.allCases
    
    private let noticeService = NoticeFirestoreService()
    private var cancellable = Set<AnyCancellable>()
    @Published var isLoading: Bool = false
    @Published var activeNoticeType: [NoticeType] = []
    @Published var allNotices:[Notice] = []
    @Published var likeNotices: [LikeNoticeObservableModel] = []
    @Published var commentNotices: [CommentNoticeObservableModel] = []
    @Published var followNotices: [RequestNoticeObservableModel] = []
    @Published var selectedCategory: Int = 0
    @Published var isUpdateReadStatus: Bool = false
    @Published var isErrorAlert: Bool = false
    @Published var errorMessage: String = ""
    
    func getNotice(appState: AppState, userID: String) async {
        self.noticeService.getAllNotices(userID: userID)
            .sink { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .finished:
                    self.confirmNotice(appState: appState)
                case .failure(let error):
                    self.isErrorAlert = true
                    self.errorMessage = error.errorMessage
                }
            } receiveValue: { [weak self] (likeNotices, commentNotices, followNotices) in
                guard let self = self else { return }
                self.likeNotices = []
                self.commentNotices = []
                self.followNotices = []
                self.likeNotices = likeNotices
                self.commentNotices = commentNotices
                self.followNotices = followNotices
            }
            .store(in: &self.cancellable)
    }
    
    func confirmNotice(appState: AppState) {
        let commentNoticeReadStatus:[Bool] = self.commentNotices.map { $0.isRead }
        let followNoticeReadStatus:[Bool] = self.followNotices.map { $0.isRead }
        let allNoticesReadStatus:[Bool] = commentNoticeReadStatus + followNoticeReadStatus
        
        if commentNoticeReadStatus.contains(false) {
            self.activeNoticeType.append(.comment)
        } else {
            self.activeNoticeType = self.activeNoticeType.compactMap { notice in
                if notice == .comment {
                    return nil
                } else {
                    return notice
                }
            }
        }
        
        if followNoticeReadStatus.contains(false) {
            self.activeNoticeType.append(.friend)
        } else {
            self.activeNoticeType = self.activeNoticeType.compactMap { notice in
                if notice == .friend {
                    return nil
                } else {
                    return notice
                }
            }
        }
        
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
    
    func getCommentNotice(userID: String, appState: AppState){
        self.noticeService.getCommentNoticeInfo(userID: userID)
            .sink { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .finished:
                    self.confirmNotice(appState: appState)
                case .failure(let error):
                    self.isErrorAlert = true
                    self.errorMessage = error.errorMessage
                }
            } receiveValue: { [weak self] commentNotices in
                guard let self = self else { return }
                self.commentNotices = []
                self.commentNotices = commentNotices
                self.confirmNotice(appState: appState)
            }
            .store(in: &self.cancellable)
    }
    
    func getLikeNotice(userID: String) {
        self.noticeService.getLikeNoticeInfo(userID: userID)
            .sink { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .finished:
                    print("finished")
                case .failure(let error):
                    self.isErrorAlert = true
                    self.errorMessage = error.errorMessage
                }
            } receiveValue: { [weak self] likeNotices in
                guard let self = self else { return }
                self.likeNotices = []
                self.likeNotices = likeNotices
            }
            .store(in: &self.cancellable)
    }
    
    func getRequestNotice(userID: String, appState: AppState) {
        self.noticeService.getRequestNoticeInfo(userID: userID)
            .sink { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .finished:
                    self.confirmNotice(appState: appState)
                case .failure(let error):
                    self.isErrorAlert = true
                    self.errorMessage = error.errorMessage
                }
            } receiveValue: { [weak self] followNotices in
                guard let self = self else { return }
                self.followNotices = []
                self.followNotices = followNotices
                self.confirmNotice(appState: appState)
            }
            .store(in: &self.cancellable)
    }
    
    func updateReadStatus(
        noticeType:String,
        noticeID: String,
        userID: String,
        appState: AppState
    ) {
        self.noticeService
            .updateReadStatus(
                noticeType: noticeType,
                userID: userID,
                noticeID: noticeID
            )
            .sink { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .finished:
                    self.confirmNotice(appState: appState)
                case .failure(let error):
                    self.isErrorAlert = true
                    self.errorMessage = error.errorMessage
                }
            } receiveValue: { _ in }
            .store(in: &self.cancellable)
    }
    
    // 一括既読機能
    func updateAllNoticeReadStatus(userID: String, appState: AppState) {
        self.isLoading = true
        
        let unreadCommentNoticeIDs = self.commentNotices.filter { $0.isRead == false }.map { $0.id }
        let unreadRequestNoticeIDs = self.followNotices.filter { $0.isRead == false }.map { $0.id }
        
        let commentUpdatePublisher:[AnyPublisher<Void, AppError>] = unreadCommentNoticeIDs.map { id in
            self.noticeService.updateReadStatus(noticeType: "CommentNotice", userID: userID, noticeID: id)
        }
        
        let requestUpdatePublisher:[AnyPublisher<Void, AppError>] = unreadRequestNoticeIDs.map { id in
            self.noticeService.updateReadStatus(noticeType: "RequestNotice", userID: userID, noticeID: id)
        }
        
        // set publisher to concurrent
        let updatePublisher = Publishers.MergeMany(commentUpdatePublisher + requestUpdatePublisher)
        
        
        // subscribe
        updatePublisher.sink { [weak self] completion in
            guard let self = self else { return }
            switch completion {
            case .finished:
                self.isLoading = false
//                self.getNotice(appState:appState, userID: userID)
            case .failure(let error):
                self.errorMessage = error.errorMessage
                self.isErrorAlert = true
            }
        } receiveValue: { _ in }.store(in: &self.cancellable)
    }
}
