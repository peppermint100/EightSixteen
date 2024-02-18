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
    
    private var todayIndicator = TodayIndicatorView()
    private var fastingCountView = FastingCountView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        coordinator?.childDidFinish(coordinator)
    }
    
    func bindViewModel(viewModel: FastingViewModel) {
        todayIndicator.bindDate(viewModel.dateSubject)
        fastingCountView.bindFastingCount(viewModel.fastingCount)
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(todayIndicator)
        view.addSubview(fastingCountView)
        
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
    }
}
