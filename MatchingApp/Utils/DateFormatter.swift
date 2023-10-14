//
//  DateFormatter.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/06/05.
//

import Foundation

struct DateFormat {
    static func timeFormat(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .none
        dateFormatter.timeStyle = .short
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    static func dateFormat(date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    static func dayFormat(date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateFormat = "M/d (E)"  // Eは曜日を表します
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    static func customDateFormat(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd HH:mm"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    static func relativeDateFormat(date: Date) -> String {
        let now = Date()
        let calendar = Calendar.current
        let timeDifference = now.timeIntervalSince(date)
        
        if timeDifference < 60 { // 60秒未満であれば
            return "数秒前"
        } else if timeDifference < 3600 { // 1時間未満であれば
            return "\(Int(timeDifference / 60))分前"
        } else if timeDifference < 86400 { // 24時間未満であれば
            return "\(Int(timeDifference / 3600))時間前"
        } else if timeDifference < 2592000 { // 30日未満であれば (30 * 24 * 3600 = 2592000)
            let days = calendar.dateComponents([.day], from: date, to: now).day ?? 0
            return "\(days)日前"
        } else if timeDifference < 31536000 { // 1年未満であれば (365 * 24 * 3600 = 31536000)
            let months = calendar.dateComponents([.month], from: date, to: now).month ?? 0
            return "\(months)ヶ月前"
        } else {
            let years = calendar.dateComponents([.year], from: date, to: now).year ?? 0
            return "\(years)年前"
        }
    }
    
    static func isSameDay(date1: Date, date2: Date) -> Bool {
        let calendar = Calendar.current
        return calendar.isDate(date1, inSameDayAs: date2)
    }
}
