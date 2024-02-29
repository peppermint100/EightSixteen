//
//  Fasting.swift
//  EightSixteen
//
//  Created by peppermint100 on 2/18/24.
//

import Foundation

class Fasting {
    let now = Date()
    var onProgress: Bool = false
    var startedAt: Date
    var fastingTime: TimeInterval
    
    let calendar = Calendar.current
    
    init() {
        self.startedAt = now
        self.fastingTime = 16 * 3600
    }
    
    init(startedAt: Date, fastingTime: TimeInterval) {
        self.startedAt = startedAt
        self.fastingTime = fastingTime
    }
    
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
    
    func start(from startedAt: Date, fastingTime: TimeInterval) {
        self.onProgress = true
        self.startedAt = startedAt
        self.fastingTime = fastingTime
    }
}
