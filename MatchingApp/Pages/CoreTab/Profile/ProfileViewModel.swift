//
//  ProfileViewModel.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/06/07.
//

import Foundation
import Combine
import UserNotifications

class ProfileViewModel: ObservableObject {
    @Published var isSettingScreen: Bool = false
    @Published var isWebView: Bool = false
    @Published var webUrlString: String = ""
    @Published var isNotificationScreen: Bool = false
    @Published var isPairProfileScreen: Bool = false
    @Published var isNoticeAllow: Bool = true
    @Published var scrollOffset: CGFloat = 0
    @Published var isErrorAlert: Bool = false
    @Published var errorMessage: String = ""
    private let center = UNUserNotificationCenter.current()
    private var cancellable = Set<AnyCancellable>()
    
    
    func requestAuthorization() async {
        do {
            let requestResult = try await center.requestAuthorization(options: [.alert, .sound, .badge])
            DispatchQueue.main.async {
                self.isNoticeAllow = requestResult
            }
        } catch {
            self.errorMessage = error.localizedDescription
            self.isErrorAlert = true
        }
    }
    
    func checkNotificationAuthorizationStatus() {
        DispatchQueue.main.async {
            self.center.getNotificationSettings { settings in
                switch settings.authorizationStatus {
                case .authorized:
                    break
                case .denied:
                    Task {
                      await self.requestAuthorization()
                    }
                case .notDetermined:
                    Task {
                      await self.requestAuthorization()
                    }
                case .provisional:
                    Task {
                      await self.requestAuthorization()
                    }
                case .ephemeral:
                    Task {
                      await self.requestAuthorization()
                    }
                @unknown default:
                    fatalError("Unknown authorization status")
                }
            }
        }
    }
}
