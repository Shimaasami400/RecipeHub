//
//  RecipeNetworkService.swift
//  RecipeHub
//
//  Created by Shimaa on 16/08/2024.
//

import Foundation
import Alamofire

protocol RecipeServiceProtocol {
    func fetchRecipes(query: String, completion: @escaping (Result<[Recipe], Error>) -> Void)
}

class RecipeNetworkService: RecipeServiceProtocol {
    
    func fetchRecipes(query: String, completion: @escaping (Result<[Recipe], Error>) -> Void) {
        let url = "https://api.edamam.com/api/recipes/v2"
        let parameters: [String: String] = [
            "type": "public",
            "q": query,
            "app_id": "d73fe640",
            "app_key": "28d26718185d8b400ab1de1c14b6dc70"
        ]
        
        AF.request(url, parameters: parameters).validate().responseDecodable(of: RecipeResponse.self) { response in
            switch response.result {
            case .success(let recipeResponse):
                let recipes = recipeResponse.hits.map { $0.recipe }
                completion(.success(recipes))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

