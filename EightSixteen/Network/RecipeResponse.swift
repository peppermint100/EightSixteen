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
    let thumbnailUrl: String
    let material: String
    let way: String
    let category: String
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
    
    var httpsThumbnailUrl: URL? {
        if var urlComponents = URLComponents(string: thumbnailUrl) {
            urlComponents.scheme = "https"
            if let secureURL = urlComponents.url {
                return secureURL
            }
        }
        
        return nil
    }
    
    enum CodingKeys: String, CodingKey {
        case thumbnailUrl = "ATT_FILE_NO_MAIN"
        case material = "RCP_PARTS_DTLS"
        case category = "RCP_PAT2"
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
