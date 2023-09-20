//
//  SelectedTab.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/08/24.
//

import Foundation

class SelectedTab: ObservableObject {
    static let shared = SelectedTab()
    @Published var selectedTab: Tab = .home
}
