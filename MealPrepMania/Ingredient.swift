//
//  Ingredient.swift
//  MealPrepMania
//
//  Created by Jennifer Foster on 11/27/16.
//  Copyright © 2016 Jennifer Foster. All rights reserved.
//

import Foundation

class Ingredient {
    var id: Int
    var name: String
    var measurement: String
    var quantity: Float
    
    init(id: Int, name: String, measurement: String, quantity: Float) {
        self.id = id
        self.name = name
        self.measurement = measurement
        self.quantity = quantity
    }
}