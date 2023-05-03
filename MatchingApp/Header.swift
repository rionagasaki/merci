//
//  Header.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/01.
//

import Foundation

struct Header: Hashable {
    var headerTitle: String
    var headerImageString: String
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(headerTitle)
        hasher.combine(headerImageString)
    }
}
