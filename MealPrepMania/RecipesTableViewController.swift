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
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Get all Recipes
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
    
    @IBAction func addNewRecipe(sender: AnyObject) {
        mealPrepManiaAPI.addRecipe {
            (newRecipe)->Void in
            self.recipes.append(newRecipe)
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
                self.tableView.selectRowAtIndexPath(NSIndexPath.init(forRow: self.recipes.count - 1, inSection: 0), animated: true, scrollPosition: .Bottom)
                self.performSegueWithIdentifier("ShowRecipe", sender: self)
            })
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
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