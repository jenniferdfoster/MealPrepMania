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
        
        let r = Recipe(id: "5", title: "Tasty Cakes")
        recipes.append(r)
        self.tableView.reloadData()
        
//        mealPrepManiaAPI.fetchAllRecipes{
//            (allRecipes)->Void in
//            self.recipes = allRecipes
//            dispatch_async(dispatch_get_main_queue(), { self.tableView.reloadData() })
//        }
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
                //let listsViewController = segue.destinationViewController as! ListsViewController
                //listsViewController.Recipe = Recipe
                //listsViewController.trelloAPI = self.trelloAPI
            }
        }
    }
}