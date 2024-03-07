//
//  RecipeAPIManager.swift
//  EightSixteen
//
//  Created by peppermint100 on 3/6/24.
//

import Foundation
import RxSwift
import Alamofire

enum RecipeError: Error {
}

class RecipeAPIManager {
    static let shared = RecipeAPIManager()
    
    private var baseUrl: String {
        if let path = Bundle.main.path(forResource: "Credentials", ofType: "plist") {
            if let dict = NSDictionary(contentsOfFile: path) as? [String: AnyObject] {
                if let apiKey = dict["RECIPE_API_KEY"] as? String {
                    return "https://openapi.foodsafetykorea.go.kr/api/\(apiKey)/COOKRCP01/json"
                }
            }
        }
        
        return ""
    }
    
    func fetchRecipes(from: Int, to: Int) -> Observable<Result<RecipeResponse, RecipeError>>{
        let url = "\(baseUrl)/\(from)/\(to)"
        return Observable.create { observer -> Disposable in
            AF.request(
                url, method: .get
            )
            .validate(statusCode: 200..<300)
            .validate(contentType: ["application/json"])
            .responseDecodable(of: RecipeResponse.self) { response in
                switch response.result {
                case .success(let data):
                    observer.onNext(.success(data))
                case .failure(let error):
                    NSLog(error.localizedDescription)
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
}
