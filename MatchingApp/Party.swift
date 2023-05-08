//
//  Party.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/08.
//

struct Party: Decodable {
    var party_id: String
    var title: String
    var description: String
    var place: String
    var date: String
    var women:[String]
    var men: [String]
}


