//
//  FastingCoordinator.swift
//  EightSixteen
//
//  Created by peppermint100 on 2/17/24.
//

import UIKit

class FastingCoordinator: Coordinator {
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let vc = FastingViewController()
        let viewModel = FastingViewModel()
        vc.coordinator = self
        vc.viewModel = viewModel
        vc.bindViewModel()
        navigationController.pushViewController(vc, animated: true)
    }
}
