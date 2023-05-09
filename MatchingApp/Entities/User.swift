//
//  User.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/01.
//

import Foundation

struct User: Codable {
    var userId: String
    var name: String
    var age: String
    var mainIcon: String
    var subImages: [String]

    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case name = "name"
        case age = "age"
        case mainIcon = "main_icon"
        case subImages = "sub_images"
    }
}


