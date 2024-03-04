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
    
    struct Input {
        let startFastingButtonTapped: Observable<Void>
        let endFastingButtonTapped: Observable<Void>
        let barButtonItemTapped: Observable<Void>
        let trash: Observable<Void>
    }
    
    struct Output {
        let showFasting: BehaviorSubject<Bool>
        let fasting: BehaviorSubject<Fasting>
    }
    
    func transform(_ input: Input) -> Output {
        let fasting = FastingManager.shared.load()
        let showFastingObservable = BehaviorSubject(value: fasting != nil)
        let fastingObservable: BehaviorSubject<Fasting>
        
        if let fasting = fasting { fastingObservable = BehaviorSubject(value: fasting) }
        else { fastingObservable = BehaviorSubject(value: Fasting())}
        
        configureBarButtonItem(input.barButtonItemTapped, input.trash, fastingObservable, showFasting: showFastingObservable)
        configureStartFastingButtonTapped(input.startFastingButtonTapped, showFastingObservable, fastingSubject: fastingObservable, fasting: fasting)
        
        let output = FastingViewModel.Output(
            showFasting: showFastingObservable,
            fasting: fastingObservable
        )
        
        return output
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
        fastingSubject: BehaviorSubject<Fasting>, fasting: Fasting?) {
        tapped.subscribe(onNext: { [weak self] in
            let fasting = Fasting()
            self?.coordinator?.presentFastingComposeVC(fasting: fasting) { fastingCreated, fasting in
                showFasting.onNext(fastingCreated)
                fastingSubject.onNext(fasting)
                print(fasting)
            }
        })
        .disposed(by: disposeBag)
    }
    
    private func configureEndFastingButton(_ tapped: Observable<Void>, onProgressSubject: BehaviorSubject<Bool>) {
        FastingManager.shared.clear()
        onProgressSubject.onNext(false)
    }
}
