//
//  Fasting.swift
//  EightSixteen
//
//  Created by peppermint100 on 2/18/24.
//

import Foundation

struct Fasting: Codable {
    static let defaultFastingHours = 16
    
    var startedAt: Date
    var fastingTimeHours: Int
    
    init() {
        self.startedAt = Date()
        self.fastingTimeHours = Fasting.defaultFastingHours
    }
    
    init(startedAt: Date, fastingTimeHours: Int) {
        self.startedAt = startedAt
        self.fastingTimeHours = fastingTimeHours
    }
    
    var fastingHoursRange: [Int] {
        let startedAtHour = Calendar.current.component(.hour, from: startedAt)
        var result = [Int]()
        for hour in stride(from: startedAtHour, to: startedAtHour + fastingTimeHours, by: 1) {
            result.append(hour % 24)
        }
        return result
    }
    
    var endedAt: Date {
        return startedAt.addingTimeInterval(TimeInterval(3600 * fastingTimeHours))
    }
    
    var fastingTimeRemaining: TimeInterval {
        let now = Date()
        let nowHour = Calendar.current.component(.hour, from: now)
        if !fastingHoursRange.contains(nowHour) {
            return 0
        }
        
        let nowIndex = fastingHoursRange.firstIndex(of: nowHour)!
        let hours = fastingHoursRange.count - nowIndex - 1
        let nowMinutes = Calendar.current.component(.minute, from: now)
        let nowSeconds = Calendar.current.component(.second, from: now)
        let startedAtMinutes = Calendar.current.component(.minute, from: startedAt)
        let startedAtSeconds = Calendar.current.component(.second, from: startedAt)
        
        let minutesToSeconds = startedAtMinutes == 0 ? (60 - nowMinutes) * 60 : (60 - (nowMinutes % startedAtMinutes)) * 60
        let seconds = startedAtSeconds == 0 ? (60 - nowSeconds) : 60 - (nowSeconds % startedAtSeconds)
        
        return TimeInterval(
            (hours * 3600)
            + minutesToSeconds
            + seconds)
    }
    
    var fastingDayCount: Int {
        let now = Date()
        return now.daysBetween(startedAt) + 1
    }
    
    var fastingRatio: Double {
        let fastingTimeProgressed = Double(fastingTimeHours * 3600) - fastingTimeRemaining
        return fastingTimeProgressed / Double(fastingTimeHours * 3600)
    }
}
