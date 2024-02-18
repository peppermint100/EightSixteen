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
}
