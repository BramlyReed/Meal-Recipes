//
//  SavedMeal.swift
//  Meal Recipes
//
//  Created by Stas on 10.12.2020.
//

import Foundation
import RealmSwift

class SavedMeal: Object{
    @objc dynamic var id: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var imageURL: String = ""
    @objc dynamic var ingredients: String = ""
    @objc dynamic var instructions: String = ""
    
    convenience init(id: String, name: String, imageURL: String, ingredients: String, instructions: String){
        self.init()
        self.id = id
        self.name = name
        self.imageURL = imageURL
        self.ingredients = ingredients
        self.instructions = instructions
    }
}

