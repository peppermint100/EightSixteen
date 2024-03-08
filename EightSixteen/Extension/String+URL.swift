//
//  String+URL.swift
//  EightSixteen
//
//  Created by peppermint100 on 3/7/24.
//

import Foundation

extension String {
    func httpsURL() -> URL? {
        if var urlComponents = URLComponents(string: self) {
            urlComponents.scheme = "https"
            if let secureURL = urlComponents.url {
                return secureURL
            }
        }
        
        return nil
    }
}
