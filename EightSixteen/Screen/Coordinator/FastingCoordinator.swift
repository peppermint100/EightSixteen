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
        viewModel.coordinator = self
        vc.viewModel = viewModel
        navigationController.pushViewController(vc, animated: true)
    }
    
    func presentFastingComposeVC(fasting: Fasting, onDismiss: @escaping (Bool, Fasting) -> Void) {
        let vc = FastingComposeViewController()
        let viewModel = FastingComposeViewModel(onDismiss: onDismiss)
        vc.sheetPresentationController?.prefersGrabberVisible = true
        vc.viewModel = viewModel
        viewModel.coordinator = self
        navigationController.present(vc, animated: true)
    }
    
    func dismissByStartFastingButton() {
        navigationController.dismiss(animated: true)
    }
    
    func alertByEndFastingButton(onOk: @escaping (UIAlertAction) -> Void) {
        guard let vc = navigationController.topViewController else { return }
        let alert = UIAlertController(title: "단식을 종료합니다", message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "종료", style: .destructive, handler: onOk)
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        alert.addAction(cancelAction)
        alert.addAction(okAction)
        vc.present(alert, animated: true)
    }
    
    func pushToRecipeListVC() {
        let vc = RecipeListViewController()
        navigationController.pushViewController(vc, animated: true)
    }
}
