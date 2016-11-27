//
//  MenuItem.swift
//  MealPrepMania
//
//  Created by Jennifer Foster on 11/27/16.
//  Copyright © 2016 Jennifer Foster. All rights reserved.
//

import Foundation

class MenuItem {
    var recipe: Recipe
    var date: NSDate
    
    init(recipe: Recipe, date: NSDate) {
        self.recipe = recipe
        self.date = date
    }
}