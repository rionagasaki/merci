//
//  TodoCategory.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/14.
//

import Foundation

struct TodoCategory: Identifiable, Hashable {
    var id = UUID()
    let popImage: String
    let title: String
}
