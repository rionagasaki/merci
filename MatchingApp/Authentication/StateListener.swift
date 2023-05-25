//
//  StateListener.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/21.
//

import Foundation
import FirebaseAuth

class StateListener {
    
    private init(){}
    
    static let shared = StateListener()
    
    func stateListener(completion: @escaping (User?)-> Bool){    }
}
