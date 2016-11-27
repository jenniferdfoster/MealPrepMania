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
    var recipe: Recipe = Recipe(id: 1, title: "boo")
    var myTextField: UITextField = UITextField()
    
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
    
    @IBAction func addToMenu(sender: AnyObject) {
        let datePicker = UIDatePicker()

        let ac = UIAlertController(title: "What Day?", message: nil, preferredStyle: .Alert)
        ac.addTextFieldWithConfigurationHandler({
            (textField) -> Void in
            datePicker.datePickerMode = .Date
            datePicker.addTarget(self, action: #selector(RecipeDetailsViewController.dateSelected(_:)), forControlEvents: UIControlEvents.ValueChanged)
            datePicker.date = NSDate()
            self.myTextField = textField
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateStyle = .MediumStyle
            self.myTextField.text = dateFormatter.stringFromDate(datePicker.date)
            textField.inputView = datePicker
        })
        ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: {
            alert -> Void in
            // Add recipe to menu on specified date
            let mi = MenuItem(recipe: self.recipe, date: datePicker.date)
            //TODO: Save Menu Item to backend
            print("Created Menu Item on \(mi.date)")
            // Add ingredients to grocery list
            for ingredient in self.recipe.ingredients {
                let gi = GroceryListItem(ingredient: ingredient, isPurchased: false)
                print ("Added grocery list item \(gi.ingredient.name)")
            }
        }))

        ac.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        presentViewController(ac, animated: true, completion: nil)
    }
    
    @IBAction func deleteRecipe(sender: AnyObject) {
        mealPrepManiaAPI.deleteRecipe(self.recipe.id)
    }
    
    func dateSelected(datePicker:UIDatePicker)
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        let date = datePicker.date
        myTextField.text = dateFormatter.stringFromDate(date)
    }
}