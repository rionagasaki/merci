//
//  Status.swift
//  SNSTictok
//
//  Created by Rio Nagasaki on 2023/07/18.
//

import Foundation

/// Show status.
public enum Status: String, Decodable, Equatable, Hashable {

    /// Rumoured.
    case rumoured = "Rumored"
    // Planned.
    case planned = "Planned"
    /// In production.
    case inProduction = "In Production"
    /// Post production.
    case postProduction = "Post Production"
    /// Released.
    case released = "Released"
    /// Cancelled.
    case cancelled = "Canceled"

}

extension Status {

    private enum CodingKeys: String, CodingKey {
        case rumoured = "rumored"
        // Planned.
        case planned = "planned"
        /// In production.
        case inProduction = "in_production"
        /// Post production.
        case postProduction = "post_production"
        /// Released.
        case released = "released"
        /// Cancelled.
        case cancelled = "canceled"
    }
}
