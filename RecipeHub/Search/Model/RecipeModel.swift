//
//  RecipeModel.swift
//  RecipeHub
//
//  Created by Shimaa on 16/08/2024.
//

import Foundation

struct RecipeResponse: Codable {
    let hits: [RecipeHit]
}

struct RecipeHit: Codable {
    let recipe: Recipe
}

struct Recipe: Codable {
    let label: String
    let image: String
    let source: String
    let url: String
    let calories: Double
    let totalWeight: Double
    let totalTime: Double
    let healthLabels: [String]?
    let ingredients: [Ingredient]? 
    
}

struct Ingredient: Codable {
    let text: String
    let weight: Double
}


