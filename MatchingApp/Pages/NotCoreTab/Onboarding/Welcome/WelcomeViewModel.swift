//
//  WelcomeViewModel.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/07/04.
//

import Foundation
import SwiftUI
import Combine

class WelcomeViewModel: ObservableObject {
    private let userService = UserFirestoreService()
    private let postService = PostFirestoreService()
    private let tokenData = TokenData.shared
    let uiifGeneratorMedium = UIImpactFeedbackGenerator(style: .medium)
    var guideText: String {
        if guideCount == 0 {
            return "登録ありがとうございます"
        } else if guideCount == 1 {
            return "merciは匿名の通話、チャット、お悩み相談サービスです。"
        } else if guideCount == 2 {
            return "メッセージや通話に気づきやすくなるよう、merciは通知オンを推奨します！"
        } else if guideCount == 3 {
            return "メッセージや着信に気づきやすくなるよう、merciは通知オンを推奨します！"
        }  else {
            return "気になる相手がいたら、チャット・通話で繋がろう！"
        }
    }
    @Published var guideCount: Int = 0
    @Published var invitationID: String = ""
    @Published var isErrorAlert: Bool = false
    @Published var errorMessage: String = ""
    @Published var isSuccess: Bool = false
    private var cancellable = Set<AnyCancellable>()
    
    func doneOnboarding(userModel: UserObservableModel){
        self.userService.updateUserInfo(currentUid: userModel.user.uid, key: "onboarding", value: true)
            .flatMap { _ in
                self.postService.createPost(
                    createdAt: Date.init(),
                    posterUid: userModel.user.uid,
                    posterNickName: userModel.user.nickname,
                    posterProfileImageUrlString: userModel.user.profileImageURLString,
                    text: "merciを始めたよ！みんなよろしくね。", contentImageUrlStrings: [])
            }
            .sink { completion in
                switch completion {
                case .finished:
                    self.isSuccess = true
                    self.uiifGeneratorMedium.impactOccurred()
                    self.tokenData.fetchToken()
                case .failure(let error):
                    self.isErrorAlert = true
                    self.errorMessage = error.errorMessage
                }
            } receiveValue: { _ in }.store(in: &self.cancellable)
    }
}
