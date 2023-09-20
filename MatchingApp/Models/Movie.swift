//
//  Movie.swift
//  SNSTictok
//
//  Created by Rio Nagasaki on 2023/07/12.
//

import Foundation

public struct Movie:Identifiable, Decodable, Equatable, Hashable {
    /// Movie identifier.
    public let id: Int
    /// Movie title.
    public let title: String
    /// Movie tagline.
    public let tagline: String?
    /// Original movie title.
    public let originalTitle: String?
    /// Original language of the movie.
    public let originalLanguage: String?
    /// Movie overview.
    public let overview: String?
    /// Movie runtime, in minutes.
    public let runtime: Int?
    /// Movie genres.
    public let genres: [Genre]?
    /// Movie release date.
    public var releaseDate: Date? {
        guard let releaseDateString = releaseDateString else {
            return nil
        }

        return DateFormatter.theMovieDatabase.date(from: releaseDateString)
    }
    /// Movie poster path.
    public let posterPath: URL?
    /// Movie poster backdrop path.
    public let backdropPath: URL?
    /// Movie budget, in US dollars.
    public let budget: Double?
    /// Movie revenue, in US dollars.
    public let revenue: Double?
    /// Movie's web site URL.
    public var homepageURL: URL? {
        guard let homepage = homepage else {
            return nil
        }

        return URL(string: homepage)
    }
    /// IMDd identifier.
    public let imdbID: String?
    /// Movie status.
    public let status: Status?
    /// Movie production companies.
    public let productionCompanies: [ProductionCompany]?
    /// Movie production countries.
    public let productionCountries: [ProductionCountry]?
    /// Movie spoken languages.
    public let spokenLanguages: [SpokenLanguage]?
    /// Current popularity.
    public let popularity: Double?
    /// Average vote score.
    public let voteAverage: Double?
    /// Number of votes.
    public let voteCount: Int?
    /// Has video.
    public let video: Bool?
    /// Is the movie only suitable for adults.
    public let adult: Bool?

    private let releaseDateString: String?
    
    private let homepage: String?
}

extension Movie: Comparable {

    public static func < (lhs: Movie, rhs: Movie) -> Bool {
        guard let lhsDate = lhs.releaseDate else {
            return false
        }

        guard let rhsDate = rhs.releaseDate else {
            return true
        }

        return lhsDate > rhsDate
    }

}

extension Movie {

    private enum CodingKeys: String, CodingKey {
        case id
        case title
        case tagline
        case originalTitle = "original_title"
        case originalLanguage = "original_language"
        case overview
        case runtime
        case genres
        case releaseDateString = "release_date"
        case posterPath = "poster_path"
        case backdropPath = "backdrop_path"
        case budget
        case revenue
        case imdbID = "imdb_ID"
        case status
        case homepage
        case productionCompanies = "production_companies"
        case productionCountries = "production_countries"
        case spokenLanguages = "spoken_languages"
        case popularity
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case video
        case adult
    }
}
