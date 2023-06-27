//
//  HomeViewModel.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/01.
//

import SwiftUI

class HomeViewModel: ObservableObject {
    
    let daysCategory = ["すべての日付","今すぐ","今日", "明日", "明後日", "その他の日付"]
    
    @Published var selection: Int = 0
    @Published var pairs:[PairObservableModel] = []
}
