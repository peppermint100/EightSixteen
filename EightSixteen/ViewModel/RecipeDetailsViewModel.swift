//
//  RecipeDetailsViewModel.swift
//  EightSixteen
//
//  Created by peppermint100 on 3/7/24.
//

import Foundation
import RxSwift

class RecipeDetailsViewModel {
    var coordinator: FastingCoordinator?
    var recipe: Recipe
    
    init(recipe: Recipe) {
        self.recipe = recipe
    }
    
    struct Input {
    }
    
    struct Output {
        let recipe: Observable<Recipe>
    }
    
    func transform(_ input: RecipeDetailsViewModel.Input) -> RecipeDetailsViewModel.Output {
        let recipe = Observable.just(recipe)
        return RecipeDetailsViewModel.Output(recipe: recipe)
    }
}
