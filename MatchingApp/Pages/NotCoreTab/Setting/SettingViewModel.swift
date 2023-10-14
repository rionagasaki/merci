//
//  SettingViewModel.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/07/16.
//

import Foundation
import Combine

@MainActor
final class SettingViewModel: ObservableObject {
    @Published var isSuccess: Bool = false
    @Published var isWebView: Bool = false
    @Published var webUrlString: String = ""
    @Published var isSignOutAlert: Bool = false
    @Published var isErrorAlert: Bool = false
    @Published var errorMessage: String = ""
    
    private var cancellable = Set<AnyCancellable>()
    
    func signOut() async {
        do {
            try await AuthenticationService.shared.signOut()
            self.isSuccess = true
        } catch let error as AppError {
            self.errorMessage = error.errorMessage
            self.isErrorAlert = true
        } catch {
            self.errorMessage = error.localizedDescription
            self.isErrorAlert = true
        }
    }
}
