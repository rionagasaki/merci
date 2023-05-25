//
//  AppState.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/04.
//

import SwiftUI
import UIKit

class AppState: ObservableObject {
    @Published var isLogin = (Authentication().currentUser != nil) ? true: false
    @Published var isLoading = false
}
