//
//  APIModel.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/08/04.
//

import Foundation

struct APIModel {
    struct MovieAPI: APIRequestProtocol {
        typealias RequestType = EmptyRequest
        typealias ResponseType = MoviePageableList
        
        var endpoint: String = "discover/movie"
        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "api_key", value: APISecret.shared.apikey),
            URLQueryItem(name: "language", value: "ja-JP"),
            URLQueryItem(name: "with_original_language", value: "ja")
        ]
        var httpMethod: HTTPMethod = .get
        var contentType: ContentType = .applicationJson
    }
    
    struct SimilarMovieAPI: APIRequestProtocol {
        typealias RequestType = EmptyRequest
        typealias ResponseType = MoviePageableList
        var movie_id: Int
        
        var endpoint: String {
            "movie/\(movie_id)/similar"
        }
        
        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "api_key", value: APISecret.shared.apikey),
            URLQueryItem(name: "language", value: "ja-JP"),
            URLQueryItem(name: "with_original_language", value: "ja")
        ]
        var httpMethod: HTTPMethod  = .get
        var contentType: ContentType = .applicationJson
    }
    
    struct PopularMovieAPI: APIRequestProtocol {
        typealias RequestType = EmptyRequest
        typealias ResponseType = MoviePageableList
        
        var endpoint: String = "movie/popular"
        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "api_key", value: APISecret.shared.apikey),
            URLQueryItem(name: "language", value: "ja-JP"),
            URLQueryItem(name: "with_original_language", value: "ja")
        ]
        var httpMethod: HTTPMethod  = .get
        var contentType: ContentType = .applicationJson
    }
    
    struct NowPlayingMovieAPI: APIRequestProtocol {
        typealias RequestType = EmptyRequest
        typealias ResponseType = MoviePageableList
        
        var endpoint: String = "movie/now_playing"
        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "api_key", value: APISecret.shared.apikey),
            URLQueryItem(name: "language", value: "ja-JP"),
            URLQueryItem(name: "with_original_language", value: "ja")
        ]
        var httpMethod: HTTPMethod  = .get
        var contentType: ContentType = .applicationJson
    }
    
    struct SearchMovieAPI: APIRequestProtocol {
        typealias RequestType = EmptyRequest
        typealias ResponseType = MoviePageableList
        var searchQuery: String
        var endpoint: String = "search/movie"
        
        var queryItems: [URLQueryItem] {[
            URLQueryItem(name: "query", value: searchQuery),
            URLQueryItem(name: "api_key", value: APISecret.shared.apikey),
            URLQueryItem(name: "language", value: "ja-JP"),
            URLQueryItem(name: "with_original_language", value: "ja")
        ]}
        
        var httpMethod: HTTPMethod  = .get
        var contentType: ContentType = .applicationJson
    }
    
    struct PersonAPI: APIRequestProtocol {
        typealias RequestType = EmptyRequest
        typealias ResponseType = [Movie]
        
        var endpoint: String = ""
        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "api_key", value: APISecret.shared.apikey),
            URLQueryItem(name: "language", value: "ja-JP"),
            URLQueryItem(name: "with_original_language", value: "ja")
        ]
        var httpMethod: HTTPMethod = .get
        var contentType: ContentType = .applicationJson
    }
}

struct EmptyRequest: Encodable {}

