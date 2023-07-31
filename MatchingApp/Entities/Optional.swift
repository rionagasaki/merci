//
//  Optional.swift
//  SNS
//
//  Created by Rio Nagasaki on 2023/01/06.
//

import Foundation

extension Optional where Wrapped == String {
    var orEmpty: String {
        switch self {
        case .none:
            return ""
        case .some(let wrapped):
            return wrapped
        }
    }
}

extension Optional where Wrapped == [String] {
    var orEmptyArray: [String] {
        switch self {
        case .none:
            return []
        case .some(let wrapped):
            return wrapped
        }
    }
}

extension Optional where Wrapped == Int {
    var orEmptyNum: Int {
        switch self {
        case .none:
            return 0
        case .some(let wrapped):
            return wrapped
        }
    }
}

