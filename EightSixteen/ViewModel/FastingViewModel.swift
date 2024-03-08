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
import UserNotifications

class FastingViewModel {
    
    var coordinator: FastingCoordinator?
    private var disposeBag = DisposeBag()
    private var timer: DispatchSourceTimer?
    
    struct Input {
        let startFastingButtonTapped: Observable<Void>
        let endFastingButtonTapped: Observable<Void>
        let recipeListBarButtonTapped: Observable<Void>
        let barButtonItemTapped: Observable<Void>
    }
    
    struct Output {
        let showFasting: BehaviorSubject<Bool>
        let fasting: BehaviorSubject<Fasting>
        let fastingStatusIndicatorText: BehaviorSubject<String>
    }
    
    func transform(_ input: Input) -> Output {
        checkNotificationPermission()
        
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
        
        configureRecipeListBarButtonTapped(input.recipeListBarButtonTapped)
        configureStartFastingButtonTapped(input.startFastingButtonTapped, showFastingObservable, fastingSubject: fastingObservable, timerSeconds: timerSeconds)
        configureEndFastingButton(input.endFastingButtonTapped, showFasting: showFastingObservable)
        configureFastingStatusIndicatorText(timerSeconds: timerSeconds, text: fastingStatusIndicatorText)
        configureTimer(showFastingObservable, timerSeconds: timerSeconds)
        configureBarButtonItem(input.barButtonItemTapped, fastingObservable, showFasting: showFastingObservable)
        
        let output = FastingViewModel.Output(
            showFasting: showFastingObservable,
            fasting: fastingObservable,
            fastingStatusIndicatorText: fastingStatusIndicatorText
        )
        
        return output
    }
    
    private func configureRecipeListBarButtonTapped(_ tapped: Observable<Void>) {
        tapped
            .subscribe(onNext: { [weak self] in
                self?.coordinator?.pushToRecipeListVC()
            })
            .disposed(by: disposeBag)
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
            print(fasting?.startedAt.addingTimeInterval(3600*9))
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
                self?.registerNotification(fasting)
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
        let notificationCenter = UNUserNotificationCenter.current()
        timer?.cancel()
        timer = nil
        FastingManager.shared.clear()
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [NotificationKey.fastingStart.rawValue, NotificationKey.fastingEnd.rawValue])
        showFasting.onNext(false)
    }
    
    private func checkNotificationPermission() {
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.getNotificationSettings { settings in
            switch settings.authorizationStatus {
            case .authorized:
                return
            case .notDetermined:
                notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { allowed, error in
                    guard error == nil else {
                        print("Error occured")
                        return
                    }
                }
                return
            case .denied:
                return
            default:
                print("Default")
                return
            }
        }
    }
    
    private func registerNotification(_ fasting: Fasting) {
        checkNotificationPermission()
        
        let notificationCenter = UNUserNotificationCenter.current()
        let calendar = Calendar.current
        let startTitle = "단식이 시작되었습니다."
        let startBody = "단식을 유지하되 무리하지 마세요!"
        let startDateComponent = calendar.dateComponents([.hour, .minute], from: fasting.startedAt)
        
        let endTitle = "단식이 종료되었습니다."
        let endBody = "식사 맛있게 하세요!"
        let endDateComponent = calendar.dateComponents([.hour, .minute], from: fasting.endedAt)
        
        let startContent = UNMutableNotificationContent()
        startContent.title = startTitle
        startContent.body = startBody
        startContent.sound = .default
        
        let endContent = UNMutableNotificationContent()
        endContent.title = endTitle
        endContent.body = endBody
        endContent.sound = .default
        
        let startTrigger = UNCalendarNotificationTrigger(dateMatching: startDateComponent, repeats: true)
        let endTrigger = UNCalendarNotificationTrigger(dateMatching: endDateComponent, repeats: true)
        
        let startRequest = UNNotificationRequest(identifier: NotificationKey.fastingStart.rawValue, content: startContent, trigger: startTrigger)
        let endRequest = UNNotificationRequest(identifier: NotificationKey.fastingEnd.rawValue, content: endContent, trigger: endTrigger)
        
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [NotificationKey.fastingStart.rawValue, NotificationKey.fastingEnd.rawValue])
        notificationCenter.add(startRequest)
        notificationCenter.add(endRequest)
    }
}
