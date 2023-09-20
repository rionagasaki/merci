//
//  ReloadPost.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/09/14.
//

import Foundation
import SwiftUI


class ReloadPost: ObservableObject {
    static let shared = ReloadPost()
    private init(){}
    
    @Published var isRequiredReload: Bool = false
}
