//
//  FastingViewController.swift
//  EightSixteen
//
//  Created by peppermint100 on 2/17/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class FastingViewController: UIViewController {
    
    var viewModel: FastingViewModel!
    private let disposeBag = DisposeBag()
    
    private var todayIndicator = TodayIndicatorView()
    private var fastingIndicatorView = FastingIndicatorView()
    private var fastingCircleView = FastingCircleProgressView()
    private var emptyFastingLabel: UILabel = {
        let label = UILabel()
        label.text = "현재 진행중인 단식이 없습니다."
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.textColor = .systemGray
        return label
    }()
    
    private var endFastingButton = ESAppButton(title: "단식 종료하기")
    private var startFastingButton = ESAppButton(title: "단식 시작하기")
    
    private lazy var recipeListBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "fork.knife.circle"), style: .plain, target: self, action: nil)
        button.tintColor = .label
        return button
    }()
    
    private lazy var settingBarButton: UIBarButtonItem = {
        let button = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: nil)
        button.tintColor = .label
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        setupTodayIndicator()
        bindViewModel()
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItems = [settingBarButton, recipeListBarButton]
    }
    
    private func bindViewModel() {
        let input = FastingViewModel.Input(
            startFastingButtonTapped: startFastingButton.rx.tap.asObservable(),
            endFastingButtonTapped: endFastingButton.rx.tap.asObservable(),
            recipeListBarButtonTapped: recipeListBarButton.rx.tap.asObservable(),
            settingBarButtonTapped: settingBarButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input)
        
        output.showFasting
            .bind(to: emptyFastingLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.showFasting
            .map { !$0 }
            .bind(to: fastingCircleView.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.showFasting
            .map { !$0 }
            .bind(to: fastingIndicatorView.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.showFasting
            .map { $0 }
            .bind(to: startFastingButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.showFasting
            .map { !$0 }
            .bind(to: endFastingButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.fasting
            .map { $0.fastingRatio }
            .bind(onNext: { [weak self] in
                self?.fastingCircleView.greenPathOccupationRatio = $0
                self?.fastingCircleView.setNeedsDisplay()
            })
            .disposed(by: disposeBag)
        
        output.fasting
            .map { $0.startedAt.formatTime() }
            .map { "시작 - \($0)" }
            .bind(to: fastingIndicatorView.fastingStartedAtLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.fasting
            .map { $0.endedAt.formatTime() }
            .map { "종료 - \($0)" }
            .bind(to: fastingIndicatorView.fastingEndedAtLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.fastingStatusIndicatorText
            .bind(to: fastingCircleView.timerLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.fasting
            .map { $0.fastingDayCount }
            .map { "\($0)일째 단식중" }
            .bind(to: fastingCircleView.fastingCountLabel.rx.text)
            .disposed(by: disposeBag)
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(todayIndicator)
        view.addSubview(fastingIndicatorView)
        view.addSubview(fastingCircleView)
        view.addSubview(startFastingButton)
        view.addSubview(endFastingButton)
        view.addSubview(emptyFastingLabel)
        
        todayIndicator.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(140)
        }
        
        fastingIndicatorView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(60)
            make.top.equalTo(todayIndicator.snp.bottom).offset(30)
            make.height.equalTo(70)
        }
        
        fastingCircleView.snp.makeConstraints { make in
            make.top.equalTo(fastingIndicatorView.snp.bottom)
            make.leading.trailing.equalToSuperview().inset(30)
            make.bottom.equalTo(startFastingButton.snp.top)
        }
        
        emptyFastingLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(30)
            make.top.equalTo(todayIndicator.snp.bottom)
            make.bottom.equalTo(startFastingButton.snp.top)
        }
        
        startFastingButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(60)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-10)
        }
        
        endFastingButton.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(40)
            make.height.equalTo(60)
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-10)
        }
    }
    
    private func setupTodayIndicator() {
        self.todayIndicator.today = Date()
    }
}
