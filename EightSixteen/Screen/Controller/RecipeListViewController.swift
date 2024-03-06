//
//  RecipeListViewController.swift
//  EightSixteen
//
//  Created by peppermint100 on 3/6/24.
//

import UIKit

class RecipeListViewController: UIViewController {
    
    var viewModel: RecipeListViewModel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindViewModel()
    }
    
    private func setupUI() {
        view.backgroundColor = .red
    }
    
    private func bindViewModel() {
        let input = RecipeListViewModel.Input()
        let output = viewModel.transform(input)
    }
}
