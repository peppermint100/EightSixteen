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
    
    private let pagingFrom = 1
    private let pagingTo = 8
    private let pagingStep = 6
    
    struct Input {
        let recipeCollecionViewReachedBottom: Observable<Void>
        let recipeSelected: Observable<Recipe>
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
        let recipePagingFrom = BehaviorRelay(value: pagingFrom)
        let recipePagingTo = BehaviorRelay(value: pagingTo)
        
//        configureDummyRecipes(recipes, isFetchingRecipes)
        configureRecipesPaging(isFetchingMoreRecipes, recipes, recipePagingFrom, recipePagingTo)
        configureRecipeCollectionViewReachedBottom(input.recipeCollecionViewReachedBottom, recipePagingFrom, recipePagingTo)
        configureRecipes(recipes, isFetchingRecipes)
        configureRecipeSelected(input.recipeSelected)
        
        return RecipeListViewModel.Output(
            recipes: recipes,
            navigationTitle: navigationTitle,
            isFetchingRecipes: isFetchingRecipes,
            isFetchingMoreRecipes: isFetchingMoreRecipes
        )
    }
    
    private func configureRecipesPaging(_ isFetching: BehaviorSubject<Bool>, _ recipe: BehaviorRelay<[Recipe]>, _ from: BehaviorRelay<Int>, _ to: BehaviorRelay<Int>) {
        Observable.combineLatest(from, to) { from, to in
            return (from, to)
        }
        .filter { $0.0 > 1 }
        .throttle(.seconds(1), scheduler: MainScheduler.instance)
        .subscribe(onNext: { page in
            isFetching.onNext(true)
            let from = page.0
            let to = page.1
            RecipeAPIManager.shared.fetchRecipes(from: from, to: to)
                .subscribe(
                    onNext: { response in
                        switch response {
                        case .success(let result):
                            recipe.accept(recipe.value + result.data.recipes)
                            isFetching.onNext(false)
                        case .failure:
                            isFetching.onNext(false)
                        }
                    },
                    onError: { error in isFetching.onNext(false) }
                )
                .disposed(by: self.disposeBag)
        }).disposed(by: disposeBag)
    }
    
    private func configureRecipeSelected(_ selected: Observable<Recipe>) {
        selected
            .subscribe(onNext: { [weak self] recipe in
                self?.coordinator?.pushToRecipeDetailsVC(recipe)
            })
            .disposed(by: disposeBag)
    }
    
    private func configureRecipeCollectionViewReachedBottom(_ reachedBottom: Observable<Void>, _ from: BehaviorRelay<Int>, _ to: BehaviorRelay<Int>) {
        reachedBottom
            .subscribe(onNext: { [weak self] in
                guard let pagingStep = self?.pagingStep else { return }
                from.accept(to.value + 1)
                to.accept(to.value + pagingStep)
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
                category: "굽기",
                natrium: "24",
                protein: "35",
                fat: "30",
                calories: "120",
                carbohydrate: "100",
                name: "레시피 이름",
                tip: "팁 이런저런 팁 이런저럽 팁 이런저럽 팁 이런 저런 팁들 이런 저런 팁 들이 있다.",
                manualImage01URL: "http://www.foodsafetykorea.go.kr/uploadimg/20230206/20230206054834_1675673314720.jpg",
                manualImage02URL: "http://www.foodsafetykorea.go.kr/uploadimg/20230206/20230206054834_1675673314720.jpg",
                manualImage03URL: "http://www.foodsafetykorea.go.kr/uploadimg/20230206/20230206054834_1675673314720.jpg",
                manualDesc01: "조리 설명 1",
                manualDesc02: "조리 설명 2",
                manualDesc03: "조리 설명 3"
            )
            _recipes.append(recipe)
        }
        
        recipes.accept(_recipes)
        isFetching.onNext(false)
    }
    
    private func configureRecipes(
        _ recipes: BehaviorRelay<[Recipe]>,
        _ isFetching: BehaviorSubject<Bool>
    ) {
        isFetching.onNext(true)
        
        RecipeAPIManager.shared.fetchRecipes(from: pagingFrom, to: pagingTo)
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
