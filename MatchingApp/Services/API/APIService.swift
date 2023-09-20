//
//  APIService.swift
//  SNSTictok
//
//  Created by Rio Nagasaki on 2023/07/17.
//

import Foundation

protocol APIService {
    func request<T: APIRequestProtocol>(_ model: T) async throws -> T.ResponseType
}
