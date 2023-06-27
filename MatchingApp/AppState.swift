//
//  AppState.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/04.
//

import SwiftUI
import UIKit

class AppState: ObservableObject {
    @Published var notLoggedInUser = (AuthenticationManager.shared.user != nil) ? false: true
    @Published var pairUserModel: UserObservableModel = .init()
    @Published var messageListViewInit: Bool = true
    @Published var pairManagementInit: Bool = true
    @Published var messageListNotification: Bool = false
    @Published var pairManagementNotification: Bool = false
    @Published var profileNotification: Bool = false
    @Published var isLoading = false
}
