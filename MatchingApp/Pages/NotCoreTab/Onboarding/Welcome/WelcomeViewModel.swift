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
    let setToFirestore = SetToFirestore()
    let uiifGeneratorMedium = UIImpactFeedbackGenerator(style: .medium)
    var guideText: String {
        if guideCount == 0 {
            return "登録ありがとうございます"
        } else if guideCount == 1 {
            return "これからNiNiの\n使い方について説明します"
        } else if guideCount == 2 {
            return "NiNiは友達と始める新感覚の\nマッチングアプリです"
        } else if guideCount == 3 {
            return "すでに友達からNiNi IDを受け取っている場合は\n入力してください"
        } else {
            return "気になるペアがいたら、メッセージをしてみましょう"
        }
    }
    @Published var guideCount: Int = 0
    @Published var invitationID: String = ""
    @Published var isErrorAlert: Bool = false
    @Published var errorMessage: String = ""
    @Published var isSuccess: Bool = false
    private var cancellable = Set<AnyCancellable>()
    
    func doneOnboarding(userModel: UserObservableModel){
        setToFirestore.doneOnboarding(user: userModel)
            .sink { completion in
                switch completion {
                case .finished:
                    self.isSuccess = true
                    self.uiifGeneratorMedium.impactOccurred()
                case .failure(let error):
                    self.isErrorAlert = true
                    self.errorMessage = error.errorMessage
                }
            } receiveValue: { _ in
                print("Recieve Value")
            }
            .store(in: &self.cancellable)
    }
}
