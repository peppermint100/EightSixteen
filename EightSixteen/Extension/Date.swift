//
//  Date.swift
//  EightSixteen
//
//  Created by peppermint100 on 2/18/24.
//

import Foundation

extension Date {
    func daysBetween(_ date: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: self, to: date)
        guard let day = components.day else { return 0 }
        return day
    }
    
    func timeIntervalBetween(_ date: Date, components: Set<Calendar.Component>) -> TimeInterval {
        let calendar = Calendar.current
        let fromAbs = calendar.dateComponents(components, from: self)
        let toAbs = calendar.dateComponents(components, from: date)

        let from = calendar.date(from: DateComponents(hour: fromAbs.hour, minute: fromAbs.minute, second: fromAbs.second))
        let to = calendar.date(from: DateComponents(hour: toAbs.hour, minute: toAbs.minute, second: toAbs.second))

        return abs(from!.timeIntervalSince(to!))
    }
}
