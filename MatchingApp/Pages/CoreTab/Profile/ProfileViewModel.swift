//
//  ProfileViewModel.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/06/07.
//

import Foundation
import Combine

class ProfileViewModel: ObservableObject {
    @Published var snsShareHalfSheet: Bool = false
    @Published var isSettingScreen: Bool = false
    @Published var isWebView: Bool = false
    @Published var webUrlString: String = ""
    @Published var isNotificationScreen: Bool = false
    @Published var isPairProfileScreen: Bool = false
    
    @Published var scrollOffset: CGFloat = 0
    
    private var cancellable = Set<AnyCancellable>()
    
}
