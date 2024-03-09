//
//  SettingManager.swift
//  EightSixteen
//
//  Created by peppermint100 on 3/9/24.
//

import Foundation

class SettingManager {
    
    static let shared = SettingManager()
    
    private let defaults = UserDefaults.standard
    
    func start() {
        if defaults.value(forKey: UserDefaultsKey.allowNotification.rawValue) == nil {
            defaults.set(true, forKey: UserDefaultsKey.allowNotification.rawValue)
        }
    }
    
    func getAllowNotification() -> Bool {
        return defaults.bool(forKey: UserDefaultsKey.allowNotification.rawValue)
    }
    
    func setAllowNotification(_ value: Bool) {
        defaults.set(value, forKey: UserDefaultsKey.allowNotification.rawValue)
    }
}
