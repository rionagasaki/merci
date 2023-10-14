//
//  MatchingApp.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/01.
//

import SwiftUI

@main
struct MatchingApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(AppState())
                .environmentObject(UserObservableModel(userModel: .init()))
                .onOpenURL { url in
                    let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
                    print("URL_token",urlComponents?.scheme ?? .init())
                }
        }
    }
}
