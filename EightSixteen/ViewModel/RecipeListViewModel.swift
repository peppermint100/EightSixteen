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
    
    var currentFrom = 0
    var currentTo = 10
    
    struct Input {
        let recipeCollecionViewReachedBottom: Observable<Void>
    }
    
    struct Output {
        let recipes: BehaviorRelay<[Recipe]>
        let navigationTitle: Observable<String>
        let isFetchingRecipes: BehaviorSubject<Bool>
        let isFetchingMoreRecipes: BehaviorSubject<Bool>
    }
    
    func transform(_ input: RecipeListViewModel.Input) -> RecipeListViewModel.Output {
        let recipes = BehaviorRelay<[Recipe]>(value: [])
        let navigationTitle = Observable.just("음식 목록")
        let isFetchingRecipes = BehaviorSubject<Bool>(value: true)
        let isFetchingMoreRecipes = BehaviorSubject<Bool>(value: false)
        
//        configureRecipes(recipes, isFetchingRecipes)
        configureDummyRecipes(recipes, isFetchingRecipes)
        configureRecipeCollectionViewReachedBottom(input.recipeCollecionViewReachedBottom, isFetchingMoreRecipes, recipes)
        
        return RecipeListViewModel.Output(
            recipes: recipes,
            navigationTitle: navigationTitle,
            isFetchingRecipes: isFetchingRecipes,
            isFetchingMoreRecipes: isFetchingMoreRecipes
        )
    }
    
    private func configureRecipeCollectionViewReachedBottom(_ reachedBottom: Observable<Void>, _ isFetching: BehaviorSubject<Bool>, _ recipes: BehaviorRelay<[Recipe]>) {
        reachedBottom.subscribe(onNext: { [weak self] _ in
            isFetching.onNext(true)
            guard var currentFrom = self?.currentFrom, var currentTo = self?.currentTo, let disposeBag = self?.disposeBag else{ return }
            currentFrom = currentTo + 1
            currentTo = currentFrom + 6
            RecipeAPIManager.shared.fetchRecipes(from: currentFrom, to: currentTo)
                .subscribe(onNext: { response in
                    switch response {
                    case .success(let response):
                        recipes.accept(recipes.value + response.data.recipes)
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                    isFetching.onNext(false)
                }, onError: { error in
                    isFetching.onNext(false)
                })
                .disposed(by: disposeBag)
        })
        .disposed(by: disposeBag)
    }
        
    private func configureDummyRecipes(_ recipes: BehaviorRelay<[Recipe]>, _ isFetching: BehaviorSubject<Bool>) {
        var _recipes: [Recipe] = []
        for _ in 0..<20 {
            let recipe = Recipe(
                thumbnailUrl: "http://www.foodsafetykorea.go.kr/uploadimg/20230206/20230206054834_1675673314720.jpg",
                material: "재료",
                way: "조리법",
                category: "카테고리",
                natrium: "나트륨",
                protein: "단백질",
                fat: "지방",
                calories: "칼로리",
                carbohydrate: "탄수화물",
                name: "레시피 이름",
                tip: "팁",
                manualImage01URL: "http://example.com",
                manualImage02URL: "http://example.com",
                manualImage03URL: "http://example.com",
                manualDesc01: "조리 설명 1",
                manualDesc02: "조리 설명 2",
                manualDesc03: "조리 설명 3"
            )
            _recipes.append(recipe)
        }
        
        recipes.accept(_recipes)
        isFetching.onNext(false)
    }
    
    private func configureRecipes(_ recipes: BehaviorRelay<[Recipe]>, _ isFetching: BehaviorSubject<Bool>) {
        isFetching.onNext(true)
        
        RecipeAPIManager.shared.fetchRecipes(from: currentFrom, to: currentTo)
            .subscribe(onNext: { response in
                switch response {
                case .success(let response):
                    recipes.accept(response.data.recipes)
                case .failure(let error):
                    print(error.localizedDescription)
                }
                isFetching.onNext(false)
            }, onError: { error in
                isFetching.onNext(false)
            }
            )
            .disposed(by: disposeBag)
    }
}
