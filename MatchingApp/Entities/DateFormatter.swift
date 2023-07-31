//
//  DateFormatter.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/06/05.
//

import Foundation

class DateFormat {
    static let shared = DateFormat()
    func timeFormat(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    func dateFormat(date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    func customDateFormat(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd HH:mm"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
}
