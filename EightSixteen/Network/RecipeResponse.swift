//
//  RecipeResponse.swift
//  EightSixteen
//
//  Created by peppermint100 on 3/6/24.
//

import Foundation

struct RecipeResponse: Codable {
    let data: RecipeResultData
    
    enum CodingKeys: String, CodingKey {
        case data = "COOKRCP01"
    }
}

struct RecipeResultData: Codable {
    let recipes: [Recipe]
    
    enum CodingKeys: String, CodingKey {
        case recipes = "row"
    }
}

