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
    
    var dateObservable: Observable<Date>
    var fastingCountDriver: Driver<Int>
    
    init() {
        self.fasting = Fasting()
        self.dateObservable = Observable.just(now)
        self.fastingCountDriver = Driver.just(now.daysBetween(fasting.startedAt))
    }
}
