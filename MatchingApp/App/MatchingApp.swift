//
//  MatchingAppApp.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/01.
//

import SwiftUI
import Supabase
import PartialSheet

@main
struct MatchingApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            ContentView()
                .attachPartialSheetToRoot()
                .environmentObject(AppState())
                .environmentObject(UserObservableModel(userModel: .init()))
                .environmentObject(PairObservableModel(pairModel: .init()))
        }
    }
}
