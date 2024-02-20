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
    
    var coordinator: FastingCoordinator?
    private let disposeBag = DisposeBag()
    
    private var todayIndicator = TodayIndicatorView()
    private var fastingCountView = FastingCountView()
    private var fastingCircleView = FastingCircleView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        coordinator?.childDidFinish(coordinator)
    }
    
    func bindViewModel(viewModel: FastingViewModel) {
        viewModel.dateObservable
            .bind(onNext: { [weak self] in
                self?.todayIndicator.today = $0
            })
            .disposed(by: disposeBag)
        
        viewModel.fastingCountDriver
            .map({
                return "현재 \($0)일째 단식중..."
            }).drive(fastingCountView.fastingCountLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(todayIndicator)
        view.addSubview(fastingCountView)
        view.addSubview(fastingCircleView)
        
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
            make.leading.trailing.bottom.equalToSuperview().inset(40)
            make.top.equalTo(fastingCountView.snp.bottom).offset(30)
        }
    }
}
