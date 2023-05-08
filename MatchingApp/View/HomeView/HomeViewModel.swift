//
//  HomeViewModel.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/01.
//

import SwiftUI

class HomeViewModel: ObservableObject {
    let headers:[Header] = [Header(headerTitle: "いいねを送ってみよう。", headerImageString: "Header_One"), Header(headerTitle: "あなたの知識が報酬に", headerImageString: "Header_One"), Header(headerTitle: "わからないことは何でも聞いてみよう", headerImageString: "Header_One")]
    @Published var selection: Int = 0
    @Published var users:[User] = []
    
}
