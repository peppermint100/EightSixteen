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
    
    private var endFastingButton: UIButton = {
        let button = UIButton()
        button.setTitle("단식 종료하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 22, weight: .semibold)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
        return button
    }()
    
    private var startFastingButton: UIButton = {
        let button = UIButton()
        button.setTitle("단식 시작하기", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 22, weight: .semibold)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTodayIndicator()
        bindViewModel()
    }
    
    func bindViewModel() {
        let input = FastingViewModel.Input(
            startFastingButtonTapped: startFastingButton.rx.tap.asObservable(),
            endFastingButtonTapped: endFastingButton.rx.tap.asObservable()
        )
        let output = viewModel.transform(input)
        
        output.fastingOnProgress
            .map { !$0 }
            .bind(to: fastingCircleView.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.fastingOnProgress
            .map { !$0 }
            .bind(to: fastingCountView.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.fastingOnProgress
            .map { $0 }
            .bind(to: startFastingButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.fastingOnProgress
            .map { !$0 }
            .bind(to: endFastingButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.fastingTimeProgressedRatio
            .bind(onNext: { [weak self] in
                self?.fastingCircleView.greenPathOccupationRatio = $0
                self?.fastingCircleView.setNeedsDisplay()
            })
            .disposed(by: disposeBag)
        
        output.fastingDayCount
            .map({ "\($0)일째 단식 중" })
            .bind(to: fastingCountView.fastingCountLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.fastingTimeRemainingSeconds
            .asObservable()
            .map({ seconds in
                return String(format: "%02d:%02d:%02d", seconds / 3600, (seconds % 3600) / 60, seconds % 60)
            })
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
