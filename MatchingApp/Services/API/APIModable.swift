//
//  APIModable.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/08/03.
//

import Foundation

protocol APIRequestProtocol {
    associatedtype RequestType: Encodable
    associatedtype ResponseType: Decodable
    
    var endpoint: String { get }
    var queryItems: [URLQueryItem] { get }
    var httpMethod: HTTPMethod { get }
    var contentType: ContentType { get }
}

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
}

enum ContentType: String {
    case applicationJson = "application/json"
}

