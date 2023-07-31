//
//  HobbiesViewModel.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/24.
//

import Foundation
import SwiftUI
import Combine

class UserHobbiesEditorViewModel: ObservableObject {
    @Published var selectedHobbies: [String] = []
    @Published var isSuccess: Bool = false
    @Published var isFailedStoreData: Bool = false
    private var cancellable = Set<AnyCancellable>()
    let setTofirestore = SetToFirestore()
    let hobbies = [
        "お酒", "飲み会","韓国料理","中華料理","インド料理","スイーツ好き","食べる専門","食べ歩き","自炊っ子","焼肉","お菓子作り","アートイベント巡り","シーシャ","タバコ", "アニメ","ゲーム","APEX","漫画", "コーヒー", "カフェ", "カラオケ","音楽","邦ロック","HIPHOP","K-POP", "スポーツ観戦", "読書", "スノボ", "旅行", "サウナ","映画鑑賞", "バスケ", "野球", "サッカー", "ラグビー","スキンケア", "ポエム", "ファッション", "ジム", "散歩"
    ]
    
    func storeHobbiesToFirestore(userModel: UserObservableModel) {
        setTofirestore.updateHobbies(
            uid: userModel.user.uid,
            hobbies: self.selectedHobbies
        )
            .sink { completion in
                switch completion {
                case .finished:
                    self.isSuccess = true
                case .failure(_):
                    self.isFailedStoreData = true
                }
            } receiveValue: { _ in
                print("Recieve Value")
            }
            .store(in: &self.cancellable)
    }
}
