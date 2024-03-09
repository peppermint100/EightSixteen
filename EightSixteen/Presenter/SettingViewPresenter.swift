//
//  SettingViewModel.swift
//  EightSixteen
//
//  Created by peppermint100 on 3/8/24.
//

import Foundation
import RxSwift

struct Section {
    let title: String
    let options: [SettingOption]
}

enum SettingOption {
    case switchType(model: SettingSwitchModel)
}

struct SettingSwitchModel {
    let icon: UIImage
    let iconBackgroundColor: UIColor
    let title: String
    let isActive: Bool
}

class SettingViewPresenter {
    let defaults = UserDefaults.standard
    
    private lazy var sections = [
        Section(title: "알림",
                options: [.switchType(model: SettingSwitchModel(icon: UIImage(systemName: "alarm")!, iconBackgroundColor: .systemOrange, title: "알림 허용", isActive: getAllowNotificationSetting()))])
    ]
    
    func navigationTitle() -> String {
        return "설정"
    }
    
    func numberOfSections() -> Int {
        return sections.count
    }
    
    func numberOfRowsInSection(_ section: Int) -> Int {
        return sections[section].options.count
    }
    
    func titleForHeaderInSection(_ section: Int) -> String {
        return sections[section].title
    }
    
    func getSettingOption(section: Int, row: Int) -> SettingOption {
        let section = sections[section]
        return section.options[row]
    }
    
    func getAllowNotificationSetting() -> Bool {
        return SettingManager.shared.getAllowNotification()
    }
    
    func toggleAllowNotificationSetting(_ next: Bool) {
        SettingManager.shared.setAllowNotification(next)
    }
}
