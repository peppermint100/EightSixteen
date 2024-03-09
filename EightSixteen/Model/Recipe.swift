//
//  Recipe.swift
//  EightSixteen
//
//  Created by peppermint100 on 3/9/24.
//

import Foundation

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
    let manualImage04URL: String
    let manualImage05URL: String
    let manualImage06URL: String
    let manualDesc01: String
    let manualDesc02: String
    let manualDesc03: String
    let manualDesc04: String
    let manualDesc05: String
    let manualDesc06: String
    
    var manuals: [RecipeManual] {
        var result = [RecipeManual]()
        
        if manualDesc01 != "" && manualImage01URL != "" {
            result.append(RecipeManual(desc: manualDesc01, imageUrl: manualImage01URL))
        }
        if manualDesc02 != "" && manualImage02URL != "" {
            result.append(RecipeManual(desc: manualDesc02, imageUrl: manualImage02URL))
        }
        if manualDesc03 != "" && manualImage03URL != "" {
            result.append(RecipeManual(desc: manualDesc03, imageUrl: manualImage03URL))
        }
        if manualDesc04 != "" && manualImage04URL != "" {
            result.append(RecipeManual(desc: manualDesc04, imageUrl: manualImage04URL))
        }
        if manualDesc05 != "" && manualImage05URL != "" {
            result.append(RecipeManual(desc: manualDesc05, imageUrl: manualImage05URL))
        }
        if manualDesc06 != "" && manualImage06URL != "" {
            result.append(RecipeManual(desc: manualDesc06, imageUrl: manualImage06URL))
        }
        
        return result
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
        case manualImage04URL = "MANUAL_IMG04"
        case manualImage05URL = "MANUAL_IMG05"
        case manualImage06URL = "MANUAL_IMG06"
        case manualDesc01 = "MANUAL01"
        case manualDesc02 = "MANUAL02"
        case manualDesc03 = "MANUAL03"
        case manualDesc04 = "MANUAL04"
        case manualDesc05 = "MANUAL05"
        case manualDesc06 = "MANUAL06"
    }
}
