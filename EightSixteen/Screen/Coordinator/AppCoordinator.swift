//
//  AppCoordinator.swift
//  EightSixteen
//
//  Created by peppermint100 on 2/17/24.
//

import UIKit

class AppCoordinator: Coordinator {
    var children: [Coordinator] = []
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let fastingCoordinator = FastingCoordinator(navigationController: self.navigationController)
        children.append(fastingCoordinator)
        fastingCoordinator.start()
    }
}
