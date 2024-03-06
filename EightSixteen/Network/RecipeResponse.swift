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

struct Recipe: Codable {
    let material: String
    let way: String
    let natrium: String
    let protein: String
    let fat: String
    let calories: String
    let carbohydrate: String
    let name: String
    let tip: String
    let manualImage01URL: String
    let manualImage02URL: String
    let manualImage03URL: String
    let manualDesc01: String
    let manualDesc02: String
    let manualDesc03: String
    
    enum CodingKeys: String, CodingKey {
        case material = "RCP_PARTS_DTLS"
        case way = "RCP_WAY2"
        case natrium = "INFO_NA"
        case protein = "INFO_PRO"
        case fat = "INFO_FAT"
        case calories = "INFO_ENG"
        case carbohydrate = "INFO_CAR"
        case name = "RCP_NM"
        case tip = "RCP_NA_TIP"
        case manualImage01URL = "MANUAL_IMG01"
        case manualImage02URL = "MANUAL_IMG02"
        case manualImage03URL = "MANUAL_IMG03"
        case manualDesc01 = "MANUAL01"
        case manualDesc02 = "MANUAL02"
        case manualDesc03 = "MANUAL03"
    }
}
