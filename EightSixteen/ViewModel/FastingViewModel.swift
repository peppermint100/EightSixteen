//
//  FastingViewModel.swift
//  EightSixteen
//
//  Created by peppermint100 on 2/18/24.
//

import Foundation
import RxSwift
import RxCocoa

class FastingViewModel {
    private let now = Date()
    private var fasting: Fasting
    
    var dateSubject: BehaviorSubject<Date>
    var fastingCount: Driver<Int>
    
    init() {
        self.fasting = Fasting()
        self.dateSubject = BehaviorSubject(value: now)
        self.fastingCount = Driver.just(now.daysBetween(fasting.startedAt))
    }
}
