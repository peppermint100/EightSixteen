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
        let navigationTitle: Observable<String>
    }
    
    func transform(_ input: RecipeListViewModel.Input) -> RecipeListViewModel.Output {
        let recipes = Observable<[Recipe]>.just([])
        let navigationTitle = Observable.just("음식 목록")
        configureRecipes(recipes)
        
        return RecipeListViewModel.Output(
            recipes: recipes,
            navigationTitle: navigationTitle
        )
    }
    
    private func configureRecipes(_ recipes: Observable<[Recipe]>) {
        RecipeAPIManager.shared.fetchRecipes(page: 1, size: 5)
            .subscribe(onNext: { recipes in
            })
            .disposed(by: disposeBag)
    }
}
