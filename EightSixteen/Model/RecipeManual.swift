//
//  RecipeManual.swift
//  EightSixteen
//
//  Created by peppermint100 on 3/9/24.
//

import Foundation
import RxDataSources

struct RecipeManual: Equatable, IdentifiableType {
    let desc: String
    let imageUrl: String
    let identity: String
    
    init(desc: String, imageUrl: String) {
        self.desc = desc
        self.imageUrl = imageUrl
        self.identity = desc
    }
}
