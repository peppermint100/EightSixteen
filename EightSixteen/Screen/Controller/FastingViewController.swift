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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        coordinator?.childDidFinish(coordinator)
    }
    
    func bindViewModel(viewModel: FastingViewModel) {
        todayIndicator.bindDate(dateObservable: viewModel.dateSubject)
    }
    
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(todayIndicator)
        todayIndicator.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(140)
        }
    }
}
