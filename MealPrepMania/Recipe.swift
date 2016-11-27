//
//  Recipe.swift
//  MealPrepMania
//
//  Created by Jennifer Foster on 11/27/16.
//  Copyright © 2016 Jennifer Foster. All rights reserved.
//

import Foundation

class Recipe {
    var id: Int
    var title: String
    var directions: [Direction]
    var ingredients: [Ingredient]
    
    init(id: Int, title: String) {
        self.id = id
        self.title = title
        self.directions = [Direction]()
        self.ingredients = [Ingredient]()
    }
}