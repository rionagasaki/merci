//
//  User.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/01.
//

import Foundation

struct User: Decodable {
    var user_id: String
    var name: String
    var age: Int
    var mainIcon: String
    var subImages:[String]
    var friendName: String
    var frindID: String
}


