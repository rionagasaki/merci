//
//  WelcomeViewModel.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/07/04.
//

import Foundation
import SwiftUI
import Combine

@MainActor
final class WelcomeViewModel: ObservableObject {
    private let userService = UserFirestoreService()
    private let postService = PostFirestoreService()
    private let tokenData = TokenData.shared
    private let firstOnboardText = "登録ありがとうございます"
    private let secondOnboardText = "merciは匿名の通話、チャット、お悩み相談サービスです。"
    private let thirdOnboardText = "メッセージや通話に気づきやすくなるよう、merciは通知オンを推奨します！"
    private let forthOnboardText = "気になる相手がいたら、チャット・通話で繋がろう！"
    
    private let uiifGeneratorMedium = UIImpactFeedbackGenerator(style: .medium)
    
    public var guideText: String {
        if self.guideCount == 0 {
            return self.firstOnboardText
        } else if self.guideCount == 1 {
            return self.secondOnboardText
        } else if self.guideCount == 2 {
            return self.thirdOnboardText
        } else if self.guideCount == 3 {
            return self.thirdOnboardText
        }  else {
            return self.forthOnboardText
        }
    }
    @Published var guideCount: Int = 0
    @Published var invitationID: String = ""
    @Published var isErrorAlert: Bool = false
    @Published var errorMessage: String = ""
    @Published var isSuccess: Bool = false
    
    func doneOnboarding(userModel: UserObservableModel) async {
        do {
            async let _ = self.userService.updateUserInfo(currentUid: userModel.user.uid, key: "onboarding", value: true)
            async let _ = self.postService.createPost(
                createdAt: Date.init(),
                posterUid: userModel.user.uid,
                posterNickName: userModel.user.nickname,
                posterProfileImageUrlString: userModel.user.profileImageURLString,
                text: "merciを始めたよ！みんなよろしくね。", contentImageUrlStrings: [])
            async let _ = self.tokenData.fetchToken()
            
            self.uiifGeneratorMedium.impactOccurred()
            self.isSuccess = true
            
        } catch let error as AppError {
            self.errorMessage = error.errorMessage
            self.isErrorAlert = true
        } catch {
            self.errorMessage = error.localizedDescription
            self.isErrorAlert = true
        }
    }
}
