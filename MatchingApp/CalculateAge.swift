//
//  CalculateAge.swift
//  MatchingApp
//
//  Created by Rio Nagasaki on 2023/05/28.
//

import Foundation

class CalculateAge {
    
    func calculateAge(from birthDateString: String) -> Int? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        
        guard let birthDate = dateFormatter.date(from: birthDateString) else {
            return nil
        }
        
        let currentDate = Date() // 現在の日付と時間を取得
        
        let calendar = Calendar.current
        let ageComponents = calendar.dateComponents([.year], from: birthDate, to: currentDate)
        return ageComponents.year
    }
}
