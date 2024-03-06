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
    }
    
    func transform(_ input: RecipeListViewModel.Input) -> RecipeListViewModel.Output {
        let recipes = BehaviorSubject<[Recipe]>(value: [])
        let navigationTitle = Observable.just("음식 목록")
        
        configureRecipes(recipes)
        
        return RecipeListViewModel.Output(
            recipes: recipes,
            navigationTitle: navigationTitle
        )
    }
    
    private func configureDummyRecipes(_ recipes: BehaviorSubject<[Recipe]>) {
        let _recipes: [Recipe] = [
            Recipe(thumbnailUrl: "http://www.foodsafetykorea.go.kr/uploadimg/cook/10_00028_2.png", material: "재료1", way: "조리법1", category: "찌기", natrium: "나트륨1", protein: "단백질1", fat: "지방1", calories: "칼로리1", carbohydrate: "탄수화물1", name: "레시피1", tip: "팁1", manualImage01URL: "URL1", manualImage02URL: "URL2", manualImage03URL: "URL3", manualDesc01: "설명1", manualDesc02: "설명2", manualDesc03: "설명3"),
            Recipe(thumbnailUrl: "http://www.foodsafetykorea.go.kr/uploadimg/cook/10_00028_2.png", material: "재료2", way: "조리법2", category: "날것", natrium: "나트륨2", protein: "단백질2", fat: "지방2", calories: "칼로리2", carbohydrate: "탄수화물2", name: "레시피2", tip: "팁2", manualImage01URL: "URL4", manualImage02URL: "URL5", manualImage03URL: "URL6", manualDesc01: "설명4", manualDesc02: "설명5", manualDesc03: "설명6" ),
            Recipe(thumbnailUrl: "http://www.foodsafetykorea.go.kr/uploadimg/cook/10_00028_2.png", material: "재료3", way: "조리법3", category: "삶기", natrium: "나트륨3", protein: "단백질3", fat: "지방3", calories: "칼로리3", carbohydrate: "탄수화물3", name: "레시피3", tip: "팁3", manualImage01URL: "URL7", manualImage02URL: "URL8", manualImage03URL: "URL9", manualDesc01: "설명7", manualDesc02: "설명8", manualDesc03: "설명9"),
            Recipe(thumbnailUrl: "http://www.foodsafetykorea.go.kr/uploadimg/cook/10_00028_2.png", material: "재료4", way: "조리법4", category: "튀기기", natrium: "나트륨4", protein: "단백질4", fat: "지방4", calories: "칼로리4", carbohydrate: "탄수화물4", name: "레시피4", tip: "팁4", manualImage01URL: "URL10", manualImage02URL: "URL11", manualImage03URL: "URL12", manualDesc01: "설명10", manualDesc02: "설명11", manualDesc03: "설명12"),
            Recipe(thumbnailUrl: "http://www.foodsafetykorea.go.kr/uploadimg/cook/10_00028_2.png", material: "재료5", way: "조리법5", category: "굽기", natrium: "나트륨5", protein: "단백질5", fat: "지방5", calories: "칼로리5", carbohydrate: "탄수화물5", name: "레시피5", tip: "팁5", manualImage01URL: "URL13", manualImage02URL: "URL14", manualImage03URL: "URL15", manualDesc01: "설명13", manualDesc02: "설명14", manualDesc03: "설명15")
        ]
        
        recipes.onNext(_recipes)
    }
    
    private func configureRecipes(_ recipes: BehaviorSubject<[Recipe]>) {

        RecipeAPIManager.shared.fetchRecipes(page: 1, size: 5)
            .subscribe(onNext: { response in
                switch response {
                case .success(let response):
                    recipes.onNext(response.data.recipes)
                case .failure(let error):
                    print(error.localizedDescription)
                    return
                }
            })
            .disposed(by: disposeBag)
    }
}
