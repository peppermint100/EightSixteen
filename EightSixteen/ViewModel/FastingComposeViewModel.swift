//
//  FastingComposeViewModel.swift
//  EightSixteen
//
//  Created by peppermint100 on 2/29/24.
//

import Foundation
import RxSwift

class FastingComposeViewModel {
    var onDismiss: (Bool, Fasting) -> Void
    var coordinator: FastingCoordinator?
    private var fasting: Fasting
    let disposeBag = DisposeBag()
    
    init(fasting: Fasting, onDismiss: @escaping (Bool, Fasting) -> Void) {
        self.fasting = fasting
        self.onDismiss = onDismiss
    }
    
    struct Input {
        let startedAtDate: Observable<Date>
        let fastingTimeHoursPickerChanged: Observable<(row: Int, component: Int)>
        let startFastingButtonTapped: Observable<Void>
    }
    
    struct Output {
        let fastingPeriodText: BehaviorSubject<String>
        let startedAtDateText: BehaviorSubject<String>
        let fastingTimeHourText: BehaviorSubject<String>
    }
    
    func transform(_ input: FastingComposeViewModel.Input) -> FastingComposeViewModel.Output {
        let fastingPeriodText = BehaviorSubject(value: "")
        let startedAtDateText = BehaviorSubject(value: "")
        let fastingTimeHourText = BehaviorSubject(value: "")
        let fastingTimeHours = BehaviorSubject(value: Fasting.defaultFastingHours)
        
        configureDateSubject(dateObservable: input.startedAtDate)
        configureFastingTimeHoursPicker(pickerChanged: input.fastingTimeHoursPickerChanged, text: fastingTimeHourText, fastingTimeHours: fastingTimeHours)
        configurePerioidText(startedAt: input.startedAtDate, fastingTimeHours: fastingTimeHours, text: fastingPeriodText)
        configureStartedAtDateText(startedAt: input.startedAtDate, text: startedAtDateText)
        configureStartFastingButtonTapped(input.startFastingButtonTapped)
        
        return FastingComposeViewModel.Output(
            fastingPeriodText: fastingPeriodText,
            startedAtDateText: startedAtDateText,
            fastingTimeHourText: fastingTimeHourText
        )
    }
   
    private func configureDateSubject(dateObservable: Observable<Date>) {
        dateObservable
            .subscribe(onNext: { [weak self] date in
                self?.fasting.startedAt = date
            })
            .disposed(by: disposeBag)
    }
    
    private func configureStartFastingButtonTapped(_ tapped: Observable<Void>) {
        tapped
            .subscribe(onNext: { [weak self] _ in
                guard let fasting = self?.fasting else { return }
                self?.startFasting(fasting)
            })
            .disposed(by: disposeBag)
    }
    
    private func startFasting(_ fasting: Fasting) {
        FastingManager.shared.save(fasting)
        onDismiss(true, fasting)
        coordinator?.dismissByStartFastingButton()
    }
    
    private func configureFastingTimeHoursPicker(pickerChanged: Observable<(row: Int, component: Int)>, text: BehaviorSubject<String>, fastingTimeHours: BehaviorSubject<Int>) {
        fastingTimeHours
            .map { "\($0)시간"}
            .bind(to: text)
            .disposed(by: disposeBag)
        
        pickerChanged
            .map { $0.row + 1 }
            .subscribe(onNext: { [weak self] hours in
                self?.fasting.fastingTimeHours = hours
                fastingTimeHours.onNext(hours)
            })
            .disposed(by: disposeBag)
    }
    
    private func configureStartedAtDateText(startedAt: Observable<Date>, text: BehaviorSubject<String>) {
        startedAt
            .map { $0.formatTime() }
            .subscribe(onNext: { dateString in
                text.onNext(dateString)
            })
            .disposed(by: disposeBag)
    }
    
    private func configurePerioidText(startedAt: Observable<Date>, fastingTimeHours: Observable<Int>, text: BehaviorSubject<String>) {
        Observable.combineLatest(startedAt, fastingTimeHours) { [unowned self] in
            return self.getPeriodText(from: $0, hours: $1)
        }
        .bind(to: text)
        .disposed(by: disposeBag)
    }
    
    private func getPeriodText(from: Date, hours: Int) -> String {
        let end = from.addingTimeInterval(TimeInterval(hours * 3600))
        return "\(from.formatTime()) ~ \(end.formatTime())"
    }
}
