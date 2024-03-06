//
//  RecipeListViewModel.swift
//  EightSixteen
//
//  Created by peppermint100 on 3/6/24.
//

import Foundation
import RxSwift
import RxCocoa

class RecipeListViewModel {
    var coordinator: FastingCoordinator?
    private let disposeBag = DisposeBag()
    
    struct Input {
    }
    
    struct Output {
        let recipes: Observable<[Recipe]>
    }
    
    func transform(_ input: RecipeListViewModel.Input) {
        let recipes = Observable<[Recipe]>.just([])
        configureRecipes(recipes)
    }
    
    private func configureRecipes(_ recipes: Observable<[Recipe]>) {
        RecipeAPIManager.shared.fetchRecipes(page: 1, size: 5)
            .subscribe(onNext: { recipes in
            })
            .disposed(by: disposeBag)
    }
}
