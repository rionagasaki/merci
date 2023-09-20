//
//  CloudFunctionsModelable.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/08/17.
//

import Foundation

protocol CloudFunctionsModelable {
    associatedtype Response: Decodable

    var requestParams: [String: Any] { get }
    var functionsName: String { get }
}

protocol NoRespCloudFunctionsModelable {
    var requestParams: [String: Any] { get }
    var functionsName: String { get }
}
