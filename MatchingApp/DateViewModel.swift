//
//  DateViewModel.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/05.
//

import Foundation

class DateViewModel: ObservableObject {
    let menu = ["すぐ会いたい", "日時を指定"]
    @Published var selectedMenu: String = ""
    @Published var selectedDate: Date = Date()
}
