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
