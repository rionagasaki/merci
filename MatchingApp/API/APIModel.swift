//
//  APIModel.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/09.
//

import Foundation

enum APIModel {}

extension APIModel {
    
    struct UserAPI: EndpointDefinition {
        typealias RequestType = Empty
        typealias ResponseType = [User]
        var request: RequestType
        var endPoint: String = "users"
        var httpMethod: HTTPMethod = .get
        var contentType: ContentType = .applicationJSON
    }
    
    struct UserPostAPI: EndpointDefinition {
        typealias RequestType = User
        typealias ResponseType = Empty
        var request: RequestType
        var endPoint: String = "users"
        var httpMethod: HTTPMethod = .post
        var contentType: ContentType = .applicationJSON
    }
    
    struct PartyAPI: EndpointDefinition {
        typealias RequestType = Empty
        typealias ResponseType = [Party]
        var request: RequestType
        var endPoint: String = "parties"
        var httpMethod: HTTPMethod = .get
        var contentType: ContentType = .applicationJSON
    }
    
    struct PartyPostAPI: EndpointDefinition {
        typealias RequestType = Party
        typealias ResponseType = Empty
        var request: RequestType
        var endPoint: String = "parties"
        var httpMethod: HTTPMethod = .post
        var contentType: ContentType = .applicationJSON
    }
}
