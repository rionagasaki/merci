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
    
    func fetchToken(){
        Messaging.messaging().token { token, error in
            if let error = error {
                print(error)
            } else if let token = token {
                self.token  = token
            }
        }
    }
}
