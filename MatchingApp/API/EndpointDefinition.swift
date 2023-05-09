//
//  EndpointDefinition.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/09.
//

import Foundation

protocol EndpointDefinition {
    associatedtype RequestType: Codable
    associatedtype ResponseType: Codable
    
    var endPoint: String { get }
    var httpMethod: HTTPMethod { get }
    var request: RequestType { get }
    var contentType: ContentType { get }
}
