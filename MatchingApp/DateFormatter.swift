//
//  DateFormatter.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/06/05.
//

import Foundation

class DateFormat {
    static let shared = DateFormat()
    func timeFormat(date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    func dateFormat(date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .long
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
}
