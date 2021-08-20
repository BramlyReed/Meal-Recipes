//
//  MealData.swift
//  Meal Recipes
//
//  Created by Stas on 04.12.2020.
//

import Foundation
import UIKit

struct Mealdata: Codable{
    var meals: [Meal]
}

struct Ingredient: Codable{
    let name: String
    let measure: String
}

struct Meal: Codable{
    var id: String
    var name: String
    var imageURLString: String
    var ingredients: String
    var instructions: String
    init(from decoder: Decoder) throws{
        let container = try decoder.singleValueContainer()
        let mealDictionary = try container.decode([String: String?].self)
        var index = 1
        var ingredients: [Ingredient] = []
        var stringIngredient = ""
        while let ingredient = mealDictionary["strIngredient\(index)"] as? String,
            let measure = mealDictionary["strMeasure\(index)"] as? String,
            !ingredient.isEmpty,
            !measure.isEmpty {
            ingredients.append(.init(name: ingredient, measure: measure))
            stringIngredient += "\n\(ingredients.last!.name) (\(ingredients.last!.measure))"
            index += 1
            }
        self.id = mealDictionary["idMeal"] as? String ?? ""
        self.ingredients = stringIngredient
        self.name = mealDictionary["strMeal"] as? String ?? ""
        self.imageURLString = mealDictionary["strMealThumb"] as? String ?? ""
        self.instructions = mealDictionary["strInstructions"] as? String ?? ""
    }
}

