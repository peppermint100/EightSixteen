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
        let recipes: BehaviorSubject<[Recipe]>
        let navigationTitle: Observable<String>
        let isFetchingRecipes: BehaviorSubject<Bool>
    }
    
    func transform(_ input: RecipeListViewModel.Input) -> RecipeListViewModel.Output {
        let recipes = BehaviorSubject<[Recipe]>(value: [])
        let navigationTitle = Observable.just("음식 목록")
        let isFetchingRecipes = BehaviorSubject<Bool>(value: true)
        
        configureRecipes(recipes, isFetchingRecipes)
        
        return RecipeListViewModel.Output(
            recipes: recipes,
            navigationTitle: navigationTitle,
            isFetchingRecipes: isFetchingRecipes
        )
    }
    
    private func configureDummyRecipes(_ recipes: BehaviorSubject<[Recipe]>) {
        let _recipes: [Recipe] = [
        ]
        
        recipes.onNext(_recipes)
    }
    
    private func configureRecipes(_ recipes: BehaviorSubject<[Recipe]>, _ isFetching: BehaviorSubject<Bool>) {
        isFetching.onNext(true)
        
        RecipeAPIManager.shared.fetchRecipes(page: 1, size: 10)
            .subscribe(onNext: { response in
                switch response {
                case .success(let response):
                    recipes.onNext(response.data.recipes)
                    isFetching.onNext(false)
                case .failure(let error):
                    print(error.localizedDescription)
                    isFetching.onNext(false)
                    return
                }
            })
            .disposed(by: disposeBag)
    }
}
