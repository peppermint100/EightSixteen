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
    }
    
    struct Output {
        let showFasting: BehaviorSubject<Bool>
        let fasting: BehaviorSubject<Fasting>
        let fastingStatusIndicatorText: BehaviorSubject<String>
    }
    
    func transform(_ input: Input) -> Output {
        let fasting = FastingManager.shared.load()
        let showFastingObservable = BehaviorSubject(value: fasting != nil)
        let fastingObservable: BehaviorSubject<Fasting>
        let timerSeconds: BehaviorSubject<TimeInterval>
        let fastingStatusIndicatorText = BehaviorSubject(value: "")
        
        if let fasting = fasting {
            fastingObservable = BehaviorSubject(value: fasting)
            timerSeconds = BehaviorSubject(value: fasting.fastingTimeRemaining)
        }
        else {
            let fasting = Fasting()
            fastingObservable = BehaviorSubject(value: fasting)
            timerSeconds = BehaviorSubject(value: TimeInterval(Fasting.defaultFastingHours * 3600))
        }
        
        configureBarButtonItem(input.barButtonItemTapped, fastingObservable, showFasting: showFastingObservable)
        configureStartFastingButtonTapped(input.startFastingButtonTapped, showFastingObservable, fastingSubject: fastingObservable, timerSeconds: timerSeconds)
        configureEndFastingButton(input.endFastingButtonTapped, showFasting: showFastingObservable)
        configureFastingStatusIndicatorText(timerSeconds: timerSeconds, text: fastingStatusIndicatorText)
        configureTimer(showFastingObservable, timerSeconds: timerSeconds)
        
        let output = FastingViewModel.Output(
            showFasting: showFastingObservable,
            fasting: fastingObservable,
            fastingStatusIndicatorText: fastingStatusIndicatorText
        )
        
        return output
    }
    
    private func configureFastingStatusIndicatorText(timerSeconds: BehaviorSubject<TimeInterval>, text: BehaviorSubject<String>) {
        timerSeconds
            .subscribe(onNext: {
                if $0 > 0 {
                    text.onNext($0.formatTimeIntervalToHHMMSS())
                } else {
                    text.onNext("식사 시간입니다.")
                }
            })
            .disposed(by: disposeBag)
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
                    if seconds < 0 {
                        self?.timer?.cancel()
                        self?.timer = nil
                    }
                    seconds -= 1
                    timerSeconds.onNext(seconds)
                }
                self?.timer?.resume()
            }
        })
        .disposed(by: disposeBag)
    }
    
    private func configureBarButtonItem(_ tapped: Observable<Void>, _ fasting: Observable<Fasting>, showFasting: BehaviorSubject<Bool>) {
        tapped.subscribe(onNext: { [weak self] _ in
            var fasting = FastingManager.shared.load()
            print("startedAt= ", fasting?.startedAt.addTimeInterval(3600 * 9))
            print("endedAt= ", fasting?.endedAt.addingTimeInterval(3600 * 9))
            print("hours = ", fasting?.fastingTimeHours)
            print("ratio = ", fasting?.fastingRatio)
            print("remaning = ", fasting?.fastingTimeRemaining)
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
    
    private func configureEndFastingButton(_ tapped: Observable<Void>, showFasting: BehaviorSubject<Bool>) {
        tapped
            .subscribe(onNext: { [weak self] in
                self?.coordinator?.alertByEndFastingButton(onOk: { _ in
                    self?.endFasting(showFasting)
                })
            })
            .disposed(by: disposeBag)
    }
    
    private func endFasting(_ showFasting: BehaviorSubject<Bool>) {
        timer?.cancel()
        timer = nil
        FastingManager.shared.clear()
        showFasting.onNext(false)
    }
}
