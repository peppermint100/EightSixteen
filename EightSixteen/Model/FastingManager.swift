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
    
    func load() -> Fasting {
        if let fasting = defaults.object(
            forKey: UserDefaultsKey.fasting.rawValue) as? Fasting {
            return fasting
        }
        
        return Fasting()
    }
    
    func save(fasting: Fasting) {
        defaults.setValue(fasting, forKey: UserDefaultsKey.fasting.rawValue)
    }
}
