//
//  FastingViewModel.swift
//  EightSixteen
//
//  Created by peppermint100 on 2/18/24.
//

import Foundation
import RxSwift
import RxCocoa
import Action

class FastingViewModel {
    
    var coordinator: FastingCoordinator?
    private var disposeBag = DisposeBag()
    private let timer = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
    private let fasting = FastingManager.shared.load()
    
    struct Input {
        let startFastingButtonTapped: Observable<Void>
        let endFastingButtonTapped: Observable<Void>
    }
    
    struct Output {
        let fastingTimeRemainingSeconds: BehaviorSubject<Int>
        let fastingOnProgress: Observable<Bool>
        let fastingDayCount: Observable<Int>
        let fastingTimeProgressedRatio: Observable<Double>
    }
    
    func transform(_ input: Input) -> Output {
        let fastingTimeRemainingSeconds = BehaviorSubject(value: Int(fasting.fastingTimeRemaining))
        let fastingOnProgress = Observable.just(fasting.onProgress)
        let fastingDayCount = Observable.just(fasting.fastingDayCount)
        let fastingTimeProgress = Observable.just(fasting.fastingTimeProgressed)
        let fastingTimeProgressedRatio = Observable.just(fasting.fastingTimeProgressed / fasting.fastingTime)
        
        input.startFastingButtonTapped.subscribe(onNext: { [weak self] in
            self?.presentFastingComposeVC()
        })
        .disposed(by: disposeBag)
        
        input.endFastingButtonTapped.subscribe(onNext: { [weak self] in
            self?.endFasting()
        })
        .disposed(by: disposeBag)
        
        if fasting.onProgress {
            startTimer(timeSubject: fastingTimeRemainingSeconds)
        }
        
        return FastingViewModel.Output(
            fastingTimeRemainingSeconds: fastingTimeRemainingSeconds,
            fastingOnProgress: fastingOnProgress,
            fastingDayCount: fastingDayCount,
            fastingTimeProgressedRatio: fastingTimeProgressedRatio
        )
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
    
    private func presentFastingComposeVC() {
        coordinator?.presentFastingComposeVC()
    }
    
    private func startFasting() {
    }
    
    private func endFasting() {
    }
}
