//
//  Fasting.swift
//  EightSixteen
//
//  Created by peppermint100 on 2/18/24.
//

import Foundation

struct Fasting {
    let now = Date()
    let startedAt: Date
    let fastingTime: TimeInterval
    
    let calendar = Calendar.current
    
    var endedAt: Date {
        if let endedAt = calendar.date(byAdding: .second, value: Int(fastingTime), to: startedAt) {
            return endedAt
        }
        return startedAt
    }
    
    var fastingTimeProgressed: TimeInterval {
        return Date().timeIntervalBetween(startedAt, components: [.hour, .minute, .second])
    }
    
    var fastingTimeRemaining: TimeInterval {
        return endedAt.timeIntervalBetween(Date(), components: [.hour, .minute, .second])
    }
    
    var fastingDayCount: Int {
        return startedAt.daysBetween(now) + 1
    }
}
