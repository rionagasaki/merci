//
//  MatchingAppApp.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/01.
//

import SwiftUI

@main
struct MatchingAppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(AppState())
                .environmentObject(UserObservableModel())
        }
    }
}
