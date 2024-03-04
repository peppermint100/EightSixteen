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
    private var timer: DispatchSourceTimer?
    
    struct Input {
        let startFastingButtonTapped: Observable<Void>
        let endFastingButtonTapped: Observable<Void>
        let barButtonItemTapped: Observable<Void>
        let trash: Observable<Void>
    }
    
    struct Output {
        let showFasting: BehaviorSubject<Bool>
        let fasting: BehaviorSubject<Fasting>
        let timerSeconds: BehaviorSubject<TimeInterval>
    }
    
    func transform(_ input: Input) -> Output {
        let fasting = FastingManager.shared.load()
        let showFastingObservable = BehaviorSubject(value: fasting != nil)
        let fastingObservable: BehaviorSubject<Fasting>
        let timerSeconds: BehaviorSubject<TimeInterval>
        
        if let fasting = fasting {
            fastingObservable = BehaviorSubject(value: fasting)
            timerSeconds = BehaviorSubject(value: fasting.fastingTimeRemaining)
        }
        else {
            fastingObservable = BehaviorSubject(value: Fasting())
            timerSeconds = BehaviorSubject(value: 0)
        }
        
        configureBarButtonItem(input.barButtonItemTapped, input.trash, fastingObservable, showFasting: showFastingObservable)
        configureStartFastingButtonTapped(input.startFastingButtonTapped, showFastingObservable, fastingSubject: fastingObservable, timerSeconds: timerSeconds)
        configureTimer(showFastingObservable, timerSeconds: timerSeconds)
        
        let output = FastingViewModel.Output(
            showFasting: showFastingObservable,
            fasting: fastingObservable,
            timerSeconds: timerSeconds
        )
        
        return output
    }
    
    private func configureTimer(_ showFasting: BehaviorSubject<Bool>, timerSeconds: BehaviorSubject<TimeInterval>) {
        showFasting.subscribe(onNext: { [weak self] showFasting in
            if self?.timer != nil {
                self?.timer?.cancel()
                self?.timer = nil
            }
            
            if showFasting {
                guard var seconds = try? timerSeconds.value() else { return }
                self?.timer = DispatchSource.makeTimerSource(queue: DispatchQueue.global(qos: .background))
                self?.timer?.schedule(deadline: .now(), repeating: 1)
                self?.timer?.setEventHandler {
                    seconds -= 1
                    timerSeconds.onNext(seconds)
                }
                self?.timer?.resume()
            }
        })
        .disposed(by: disposeBag)
    }
    
    private func configureBarButtonItem(_ tapped: Observable<Void>, _ trash: Observable<Void>, _ fasting: Observable<Fasting>, showFasting: BehaviorSubject<Bool>) {
        tapped.subscribe(onNext: { [weak self] _ in
            let fasting = FastingManager.shared.load()
            print("startedAt= ", fasting?.startedAt)
            print("endedAt= ", fasting?.endedAt)
            print("hours = ", fasting?.fastingTimeHours)
            print("ratio = ", fasting?.fastingRatio)
            print("remaning = ", fasting?.fastingTimeRemaining)
        })
        .disposed(by: disposeBag)
        
        trash.subscribe(onNext: {
            showFasting.onNext(false)
            FastingManager.shared.clear()
        })
        .disposed(by: disposeBag)
    }
    
    private func configureStartFastingButtonTapped(
        _ tapped: Observable<Void>, _ showFasting: BehaviorSubject<Bool>,
        fastingSubject: BehaviorSubject<Fasting>, timerSeconds: BehaviorSubject<TimeInterval>) {
        tapped.subscribe(onNext: { [weak self] in
            let fasting = Fasting()
            self?.coordinator?.presentFastingComposeVC(fasting: fasting) { fastingCreated, fasting in
                timerSeconds.onNext(fasting.fastingTimeRemaining)
                showFasting.onNext(fastingCreated)
                fastingSubject.onNext(fasting)
            }
        })
        .disposed(by: disposeBag)
    }
    
    private func configureEndFastingButton(_ tapped: Observable<Void>, onProgressSubject: BehaviorSubject<Bool>) {
        FastingManager.shared.clear()
        onProgressSubject.onNext(false)
    }
}
