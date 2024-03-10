//
//  SettingManager.swift
//  EightSixteen
//
//  Created by peppermint100 on 3/9/24.
//

import Foundation
import UserNotifications

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
    
    func setAllowNotification(_ allow: Bool) {
        defaults.set(allow, forKey: UserDefaultsKey.allowNotification.rawValue)
        
        if allow {
            if let fasting = Fasting.load() {
                fasting.registerNotifications()
            }
        } else {
            let notificationCenter = UNUserNotificationCenter.current()
            notificationCenter.removePendingNotificationRequests(withIdentifiers: [NotificationKey.fastingStart.rawValue, NotificationKey.fastingEnd.rawValue])
        }
    }
}
