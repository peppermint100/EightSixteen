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
    
    private var disposeBag = DisposeBag()
    private let timer = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
    
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
        
        let output = Output(fasting: Observable.just(fasting), fastingTimeRemainingSeconds: fastingTimeRemaining)
        
        startTimer(timeSubject: fastingTimeRemaining)
        
        return output
    }
    
    private func startTimer(timeSubject: BehaviorSubject<Int>) {
        if let seconds = try? timeSubject.value() {
            timer.map { seconds - $0 }
                .take(until: { $0 == 0 }, behavior: .inclusive)
                .subscribe(onNext: { value in
                    timeSubject.onNext(value)
                })
                .disposed(by: disposeBag)
        }
    }
}
