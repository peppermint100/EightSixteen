//
//  Fasting.swift
//  EightSixteen
//
//  Created by peppermint100 on 2/18/24.
//

import Foundation
import UserNotifications

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
        let nowMinutes = Calendar.current.component(.minute, from: now)
        let endedAtHour = Calendar.current.component(.hour, from: endedAt)
        let endedAtMinutes = Calendar.current.component(.minute, from: endedAt)
        
        if endedAtHour == nowHour {
            let offset = endedAtMinutes - nowMinutes
            if offset > 0 {
                return TimeInterval(offset * 60)
            }
        }
        
        if !fastingHoursRange.contains(nowHour) {
            return 0
        }
        
        let startedAtMinutes = Calendar.current.component(.minute, from: startedAt)
        let nowIndex = fastingHoursRange.firstIndex(of: nowHour)!
        let hours = fastingHoursRange.count - nowIndex - 1
        let nowSeconds = Calendar.current.component(.second, from: now)
        let startedAtSeconds = Calendar.current.component(.second, from: startedAt)
        let minutesToSeconds = startedAtMinutes == 0 ? (60 - nowMinutes) * 60 : (60 - (nowMinutes % startedAtMinutes)) * 60
        let seconds = startedAtSeconds == 0 ? (60 - nowSeconds) : 60 - (nowSeconds % startedAtSeconds)
        
        return TimeInterval(
            (hours * 3600)
            + minutesToSeconds
            + seconds - 60)
    }
    
    var fastingDayCount: Int {
        let now = Date()
        return now.daysBetween(startedAt) + 1
    }
    
    var fastingRatio: Double {
        let fastingTimeProgressed = Double(fastingTimeHours * 3600) - fastingTimeRemaining
        return fastingTimeProgressed / Double(fastingTimeHours * 3600)
    }
    
    func registerNotifications() {
        let notificationCenter = UNUserNotificationCenter.current()
        let calendar = Calendar.current
        let startTitle = "단식이 시작되었습니다."
        let startBody = "단식을 유지하되 무리하지 마세요!"
        let startDateComponent = calendar.dateComponents([.hour, .minute], from: startedAt)
        
        let endTitle = "단식이 종료되었습니다."
        let endBody = "식사 맛있게 하세요!"
        let endDateComponent = calendar.dateComponents([.hour, .minute], from: endedAt.addingTimeInterval(60))
        
        let startContent = UNMutableNotificationContent()
        startContent.title = startTitle
        startContent.body = startBody
        startContent.sound = .default
        
        let endContent = UNMutableNotificationContent()
        endContent.title = endTitle
        endContent.body = endBody
        endContent.sound = .default
        
        let startTrigger = UNCalendarNotificationTrigger(dateMatching: startDateComponent, repeats: true)
        let endTrigger = UNCalendarNotificationTrigger(dateMatching: endDateComponent, repeats: true)
        
        let startRequest = UNNotificationRequest(identifier: NotificationKey.fastingStart.rawValue, content: startContent, trigger: startTrigger)
        let endRequest = UNNotificationRequest(identifier: NotificationKey.fastingEnd.rawValue, content: endContent, trigger: endTrigger)
        
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [NotificationKey.fastingStart.rawValue, NotificationKey.fastingEnd.rawValue])
        notificationCenter.add(startRequest)
        notificationCenter.add(endRequest)
    }
}
