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
    
    let disposeBag = DisposeBag()
    
    struct Input {
    }
    
    struct Output {
        let fasting: Observable<Fasting>
        let fastingTimeRemainingSeconds: BehaviorSubject<Int>
    }
    
    func transform(_ input: Input) -> Output {
        var components = DateComponents()
        components.year = 2024
        components.month = 2
        components.day = 26
        components.hour = 6
        components.minute = 0
        let fasting = Fasting(startedAt: Calendar.current.date(from: components)!, fastingTime: TimeInterval(integerLiteral: 16 * 3600))
        let fastingTimeRemaining = BehaviorSubject(value: Int(fasting.fastingTimeRemaining))
        let timer = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
        timer.withLatestFrom(fastingTimeRemaining)
            .map({ $0 - 1 })
            .do(onNext: { seconds in
                if seconds < 0 { return }
            })
            .bind(to: fastingTimeRemaining)
            .disposed(by: disposeBag)
        
        return Output(fasting: Observable.just(fasting), fastingTimeRemainingSeconds: fastingTimeRemaining)
    }
}
