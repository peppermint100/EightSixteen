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
    private var fastingCountView = FastingCountView()
    private var fastingCircleView = CircleGaugeView()
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTodayIndicator()
        bindViewModel()
    }
    
    func bindViewModel() {
        let barButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItems = [barButtonItem]
        
        let input = FastingViewModel.Input(
            startFastingButtonTapped: startFastingButton.rx.tap.asObservable(),
            endFastingButtonTapped: endFastingButton.rx.tap.asObservable(),
            barButtonItemTapped: barButtonItem.rx.tap.asObservable()
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
            .bind(to: fastingCountView.rx.isHidden)
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
            .map { $0.fastingDayCount }
            .map { "\($0)일째 단식 중" }
            .bind(to: fastingCountView.fastingCountLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.fastingStatusIndicatorText
            .bind(to: fastingCircleView.timerLabel.rx.text)
            .disposed(by: disposeBag)
    }

    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(todayIndicator)
        view.addSubview(fastingCountView)
        view.addSubview(fastingCircleView)
        view.addSubview(startFastingButton)
        view.addSubview(endFastingButton)
        view.addSubview(emptyFastingLabel)
        
        todayIndicator.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(140)
        }
        
        fastingCountView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(40)
            make.top.equalTo(todayIndicator.snp.bottom).offset(30)
            make.height.equalTo(70)
        }
        
        fastingCircleView.snp.makeConstraints { make in
            make.top.equalTo(fastingCountView.snp.bottom).offset(30)
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
