//
//  Recipe.swift
//  MealPrepMania
//
//  Created by Jennifer Foster on 11/27/16.
//  Copyright © 2016 Jennifer Foster. All rights reserved.
//

import Foundation

class Recipe {
    var id: String
    var name: String
    var directions: [Direction]
    var ingredients: [Ingredient]
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
        self.directions = [Direction]()
        self.ingredients = [Ingredient]()
    }
}