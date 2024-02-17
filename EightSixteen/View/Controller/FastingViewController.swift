//
//  FastingViewController.swift
//  EightSixteen
//
//  Created by peppermint100 on 2/17/24.
//

import UIKit

class FastingViewController: UIViewController {
    
    var coordinator: FastingCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        coordinator?.childDidFinish(coordinator)
    }
}
