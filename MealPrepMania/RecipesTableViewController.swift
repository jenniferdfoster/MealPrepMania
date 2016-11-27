//
//  RecipesTableViewController.swift
//  MealPrepMania
//
//  Created by Jennifer Foster on 11/27/16.
//  Copyright © 2016 Jennifer Foster. All rights reserved.
//

import UIKit

class RecipesViewController: UITableViewController {
    
    var trelloAPI: MealPrepManiaAPI!
    var Recipes: [Recipe] = [Recipe]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Get all Recipes for the user
        trelloAPI.fetchAllRecipes{
            (allRecipes)->Void in
            self.Recipes = allRecipes
            dispatch_async(dispatch_get_main_queue(), { self.tableView.reloadData() })
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Recipes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RecipeCell", forIndexPath: indexPath)
        let Recipe = self.Recipes[indexPath.row]
        cell.textLabel?.text = Recipe.name
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        //If the triggered segue is the "ShowRecipe" segue
        if segue.identifier == "ShowRecipe" {
            //Figure out which row was just tapped
            if let row = tableView.indexPathForSelectedRow?.row {
                // Get the item associated with this row and pass it along
                let Recipe = Recipes[row]
                //let listsViewController = segue.destinationViewController as! ListsViewController
                //listsViewController.Recipe = Recipe
                //listsViewController.trelloAPI = self.trelloAPI
            }
        }
    }
}