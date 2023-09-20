//
//  Genre.swift
//  SNSTictok
//
//  Created by Rio Nagasaki on 2023/07/18.
//
import Foundation

/// Genre.
public struct Genre: Identifiable, Decodable, Equatable, Hashable {

    /// Genre Identifier.
    public let id: Int
    /// Genre name.
    public let name: String

    /// Creates a new `Genre`.
    ///
    /// - Parameters:
    ///    - id: Genre Identifier.
    ///    - name: Genre name.
    public init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
}

extension Genre {
    private enum CodingKeys: String, CodingKey {
        case id
        case name
    }
}
