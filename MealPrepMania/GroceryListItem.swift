//
//  GroceryListItem.swift
//  MealPrepMania
//
//  Created by Jennifer Foster on 11/27/16.
//  Copyright © 2016 Jennifer Foster. All rights reserved.
//

import Foundation

class GroceryListItem {
    var ingredient: Ingredient
    var isPurchased: Bool
    
    init(ingredient: Ingredient, isPurchased: Bool) {
        self.ingredient = ingredient
        self.isPurchased = isPurchased
    }
}