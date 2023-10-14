//
//  Token.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/07/20.
//

import Foundation
import Firebase

class TokenData: ObservableObject {
    static let shared = TokenData() // Singleton instance
    private init(){}
    @Published var token: String = ""
    
    func fetchToken() async throws -> Void {
        let token = try await Messaging.messaging().token()
        self.token = token
    }
}
