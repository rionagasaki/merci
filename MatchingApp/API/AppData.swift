//
//  AppData.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/08.
//

import Foundation

final class AppData {
    static let shared = AppData()
    private init() {}
    let url: URL = URL(string: "https://qtk1kc2484.execute-api.ap-northeast-1.amazonaws.com")!
}

