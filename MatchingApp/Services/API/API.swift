//
//  API.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/08/03.
//

import Foundation

class API: APIService {
    func request<T: APIRequestProtocol>(_ model: T) async throws -> T.ResponseType {
        guard let baseURL = URL(string: "https://api.themoviedb.org/3/") else {
            throw AppError.other(.invalidUrl)
        }
        let endpointURL = baseURL.appendingPathComponent(model.endpoint)
        var urlComponents = URLComponents(url: endpointURL, resolvingAgainstBaseURL: true)
        urlComponents?.queryItems = model.queryItems

        guard let finalURL = urlComponents?.url else {
            throw AppError.other(.invalidUrl)
        }
        var urlRequest = URLRequest(url: finalURL)
        urlRequest.httpMethod = model.httpMethod.rawValue
        urlRequest.setValue(model.contentType.rawValue, forHTTPHeaderField: "ContentType")
        urlRequest.setValue(APISecret.shared.accessToken, forHTTPHeaderField: "Authorization")
        
//        if let data = model.jsonData, model.httpMethod.rawValue.lowercased() == "post" {
//            urlRequest.httpBody = data
//        }
        
        let (data, _) = try await URLSession.shared.data(for: urlRequest)
        let result = try JSONDecoder().decode(T.ResponseType.self, from: data)
        return result
    }
}
