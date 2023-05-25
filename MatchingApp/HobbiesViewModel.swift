//
//  HobbiesViewModel.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/24.
//

import Foundation

class HobbiesViewModel: ObservableObject {
    let hobbies = [
        "お酒", "飲み会","シーシャ","タバコ", "アニメ","ゲーム","APEX","漫画", "コーヒー", "カフェ", "カラオケ","音楽","邦ロック","HIPHOP","K-POP", "スポーツ観戦", "読書", "スノボ", "旅行", "サウナ","映画鑑賞", "バスケ", "野球", "サッカー", "ラグビー","スキンケア", "ポエム", "ファッション", "ジム", "散歩"
    ]
    @Published var selectedHobbies: [String] = []
}
