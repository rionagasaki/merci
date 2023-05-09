//
//  API.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/09.
//

import Foundation

struct API {
    static func request<T: EndpointDefinition>(_ model: T, completion: @escaping(Result<T.ResponseType, Error>) -> Void) {
        var request = URLRequest(url: AppData.shared.url.appendingPathComponent(model.endPoint))
        request.httpMethod = model.httpMethod.rawValue
        
        URLSession.shared.dataTask(with: request) { (data, response, apiError) in
            do {
                if let error = apiError { throw error }
                guard let data = data, let apiResponse = response as? HTTPURLResponse else { return }
                print(apiResponse.statusCode)
                let dataString = String(data: data, encoding: .utf8)
                print("JSON data: \(dataString ?? "Invalid data")")
                if apiResponse.statusCode == 200 {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let responseObj = try decoder.decode(T.ResponseType.self, from: data)
                    print(responseObj)
                    completion(.success(responseObj))
                }
            } catch {
                completion(.failure(error))
            }
        }
        .resume()
    }
}
