//
//  Extension+DateFormatter.swift
//  SNSTictok
//
//  Created by Rio Nagasaki on 2023/07/18.
//

import Foundation

extension DateFormatter {

    static var theMovieDatabase: DateFormatter {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter
    }

}
