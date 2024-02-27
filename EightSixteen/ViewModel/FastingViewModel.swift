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
    
    struct Input {
    }
    
    struct Output {
        let fasting: Observable<Fasting>
    }
    
    private let now = Date()
    
    var fastingCountDriver: Driver<Int>
    
    init() {
        self.fastingCountDriver = Driver.just(2)
    }
    
    func transform(_ input: Input) -> Output {
        var components = DateComponents()
        components.year = 2024
        components.month = 2
        components.day = 26
        components.hour = 11
        components.minute = 30
        let fasting = Fasting(startedAt: Calendar.current.date(from: components)!, fastingTime: TimeInterval(integerLiteral: 16 * 3600))
        return Output(fasting: Observable.just(fasting))
    }
}
