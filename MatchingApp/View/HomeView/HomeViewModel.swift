//
//  HomeViewModel.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/01.
//

import SwiftUI

class HomeViewModel: ObservableObject {
    let categories = [TodoCategory(popImage: "All", title: "すべて"),TodoCategory(popImage: "Beer", title: "居酒屋"), TodoCategory(popImage: "Coffee", title: "カフェ"), TodoCategory(popImage: "Lunch", title: "ランチ"),TodoCategory(popImage: "Dinner", title: "ディナー"), TodoCategory(popImage: "Car", title: "ドライブ"), TodoCategory(popImage: "Book", title: "勉強会")]
    
    let daysCategory = ["すべての日付","今すぐ","今日", "明日", "明後日", "その他の日付"]
    
    @Published var selection: Int = 0
    @Published var pairs:[PairObservableModel] = []
}
