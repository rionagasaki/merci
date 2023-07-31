//
//  Token.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/07/20.
//

import Foundation
class TokenData: ObservableObject {
    static let shared = TokenData() // Singleton instance
    private init(){}
    @Published var token: String = ""
}
