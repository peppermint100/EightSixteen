//
//  FastingManager.swift
//  EightSixteen
//
//  Created by peppermint100 on 2/28/24.
//

import Foundation

class FastingManager {
    
    static let shared = FastingManager()
    private let defaults = UserDefaults.standard
    
    func dummyLoad() -> Fasting? {
        var fasting = Fasting()
        var components = DateComponents()
        components.year = 2024
        components.month = 3
        components.day = 4
        components.hour = 12
        components.minute = 0
        components.second = 0
        fasting.startedAt = Calendar.current.date(from: components)!
        fasting.fastingTimeHours = 2
        return fasting
    }
    
    func load() -> Fasting? {
        if
            let decoded = defaults.data(forKey: UserDefaultsKey.fasting.rawValue),
            let fasting = try? JSONDecoder().decode(Fasting.self, from: decoded) {
            return fasting
        }
        return nil
    }
    
    func save(_ fasting: Fasting) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(fasting) {
            defaults.set(encoded, forKey: UserDefaultsKey.fasting.rawValue)
        }
    }
    
    func clear() {
        save(Fasting())
    }
}
