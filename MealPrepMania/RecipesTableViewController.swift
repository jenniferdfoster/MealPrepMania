//
//  RecipesTableViewController.swift
//  MealPrepMania
//
//  Created by Jennifer Foster on 11/27/16.
//  Copyright © 2016 Jennifer Foster. All rights reserved.
//

import UIKit

class RecipesTableViewController: UITableViewController {
    
    var mealPrepManiaAPI: MealPrepManiaAPI!
    var recipes: [Recipe] = [Recipe]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Get all Recipes for the user
        
        let r = Recipe(id: 1, title: "Tasty Cakes")
        let ing = Ingredient(name: "cake", measurement: "tons", quantity: 3.0)
        r.ingredients.append(ing)
        let dir = Direction(id: "1", text: "Make Tasty Cakes")
        let dir2 = Direction(id: "2", text: "Enjoy Tasty Cakes")
        r.directions.append(dir)
        r.directions.append(dir2)
        
        let r2 = Recipe(id: 2, title: "Jelly Beans")
        let ing10 = Ingredient(name: "jelly", measurement: "jar", quantity: 1.0)
        let ing11 = Ingredient(name: "beans", measurement: "bag", quantity: 2.0)
        r2.ingredients.append(ing10)
        r2.ingredients.append(ing11)
        let dir10 = Direction(id: "1", text: "Take Jelly")
        let dir11 = Direction(id: "2", text: "Add Beans")
        let dir12 = Direction(id: "2", text: "Acquire Jelly Beans")
        let dir13 = Direction(id: "2", text: "Probably also acquire diabetes")
        r2.directions.append(dir10)
        r2.directions.append(dir11)
        r2.directions.append(dir12)
        r2.directions.append(dir13)
        
        recipes.append(r)
        recipes.append(r2)
        self.tableView.reloadData()
        
        mealPrepManiaAPI.fetchAllRecipes{
            (allRecipes)->Void in
            self.recipes = allRecipes
            dispatch_async(dispatch_get_main_queue(), { self.tableView.reloadData() })
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RecipeCell", forIndexPath: indexPath)
        let recipe = self.recipes[indexPath.row]
        cell.textLabel?.text = recipe.title
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //If the triggered segue is the "ShowRecipe" segue
        if segue.identifier == "ShowRecipe" {
            //Figure out which row was just tapped
            if let row = tableView.indexPathForSelectedRow?.row {
                // Get the item associated with this row and pass it along
                let recipe = recipes[row]
                let detailsViewController = segue.destinationViewController as! RecipeDetailsViewController
                detailsViewController.recipe = recipe
                detailsViewController.mealPrepManiaAPI = mealPrepManiaAPI
            }
        }
    }
}