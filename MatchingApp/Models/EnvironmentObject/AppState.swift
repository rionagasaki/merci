//
//  AppState.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/04.
//

import SwiftUI
import UIKit
import Combine

class AppState: ObservableObject {
    @Published var isHostCallReload: Bool = true
    @Published var isAttendeeCallReload: Bool = true
    @Published var tabWithNotice: [Tab] = []
    @Published var unreadMessageAllCount = 0
    @Published var isLoading = false
    
    private var cancellables: Set<AnyCancellable> = []
}
