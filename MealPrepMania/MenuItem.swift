//
//  MenuItem.swift
//  MealPrepMania
//
//  Created by Jennifer Foster on 11/27/16.
//  Copyright © 2016 Jennifer Foster. All rights reserved.
//

import Foundation

class MenuItem {
    var id: Int
    var recipe: Recipe
    var date: NSDate
    
    init(id: Int, recipe: Recipe, date: NSDate) {
        self.id = id
        self.recipe = recipe
        self.date = date
    }
}