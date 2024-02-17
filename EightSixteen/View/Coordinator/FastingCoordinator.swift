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
        vc.coordinator = self
        navigationController.pushViewController(vc, animated: true)
    }
}
