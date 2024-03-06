//
//  TimerInterval.swift
//  EightSixteen
//
//  Created by peppermint100 on 3/5/24.
//

import Foundation

extension TimeInterval {
    
    func formatTimeIntervalToHHMMSS() -> String {
        let seconds = Int(self)
        return String(format: "%02d:%02d:%02d", seconds / 3600, (seconds % 3600) / 60, seconds % 60)
    }
}
