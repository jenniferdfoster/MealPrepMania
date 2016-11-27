//
//  RecipeDetailsViewController.swift
//  MealPrepMania
//
//  Created by Jennifer Foster on 11/27/16.
//  Copyright © 2016 Jennifer Foster. All rights reserved.
//

import UIKit

class RecipeDetailsViewController: UITableViewController {
    
    var mealPrepManiaAPI: MealPrepManiaAPI!
    var recipe: Recipe = Recipe(id: "1", title: "boo")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = recipe.title
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Ingredients"
        case 1:
            return "Directions"
        default:
            return ""
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return recipe.ingredients.count
        case 1:
            return recipe.directions.count
        default:
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let ingredient = recipe.ingredients[indexPath.row]
            let cell: IngredientCell = tableView.dequeueReusableCellWithIdentifier("IngredientCell", forIndexPath: indexPath) as! IngredientCell
            cell.nameLabel.text = ingredient.name
            cell.measurementLabel.text = ingredient.measurement
            cell.quantityLabel.text = ingredient.quantity.description
            return cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("DirectionCell", forIndexPath: indexPath)
            cell.textLabel!.text = recipe.directions[indexPath.row].text
            return cell
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier("DirectionCell", forIndexPath: indexPath)
            cell.textLabel!.text = ""
            return cell
        }
    }
}