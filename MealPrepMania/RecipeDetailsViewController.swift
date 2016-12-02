//
//  RecipeDetailsViewController.swift
//  MealPrepMania
//
//  Created by Jennifer Foster on 11/27/16.
//  Copyright © 2016 Jennifer Foster. All rights reserved.
//

import UIKit

class RecipeDetailsViewController: UITableViewController, UITextFieldDelegate {
    
    var mealPrepManiaAPI: MealPrepManiaAPI!
    var recipe: Recipe = Recipe(id: 1, title: "")
    var myTextField: UITextField = UITextField()
    @IBOutlet var recipeTitleTextField: UITextField!
    
    let dateFormatter = NSDateFormatter()
    let floatFormatter = NSNumberFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Edit Recipe"
        self.recipeTitleTextField.text = self.recipe.title
        self.recipeTitleTextField.delegate = self
        self.tableView.estimatedRowHeight = 80
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        dateFormatter.dateStyle = .MediumStyle
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
    
    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        switch section {
        case 0:
            let cell = tableView.dequeueReusableCellWithIdentifier("AddIngredientCell")
            return cell!.contentView
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("AddDirectionCell")
            return cell!.contentView
        default:
            return nil
        }
    }
    
    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let ingredient = recipe.ingredients[indexPath.row]
            let cell: IngredientCell = tableView.dequeueReusableCellWithIdentifier("IngredientCell", forIndexPath: indexPath) as! IngredientCell

            cell.quantityTextField.text = floatFormatter.stringFromNumber(ingredient.quantity)
            cell.quantityTextField.tag = (indexPath.row * 10) + 1
            cell.quantityTextField.keyboardType = .DecimalPad
            cell.quantityTextField.delegate = self
            
            cell.measurementTextField.text = ingredient.measurement
            cell.measurementTextField.tag = (indexPath.row * 10) + 2
            cell.measurementTextField.delegate = self
            
            cell.nameTextField.text = ingredient.name
            cell.nameTextField.tag = (indexPath.row * 10) + 3
            cell.nameTextField.delegate = self
            return cell
        case 1:
            let cell = tableView.dequeueReusableCellWithIdentifier("DirectionCell", forIndexPath: indexPath) as! DirectionCell
            cell.directionTextField.text = recipe.directions[indexPath.row].text
            cell.directionTextField.tag = (indexPath.row) + 1000
            cell.directionTextField.delegate = self
            return cell
        default:
            let cell = tableView.dequeueReusableCellWithIdentifier("DirectionCell", forIndexPath: indexPath)
            cell.textLabel!.text = ""
            return cell
        }
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            switch indexPath.section {
            case 0:
                self.recipe.ingredients.removeAtIndex(indexPath.row)
                self.tableView.reloadData()
            case 1:
                self.recipe.directions.removeAtIndex(indexPath.row)
                self.tableView.reloadData()
            default:
                return
            }
            self.updateRecipe()
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
            //let mi = MenuItem(id: 3, recipe: self.recipe, date: datePicker.date)
            self.mealPrepManiaAPI.addMenuItem(self.recipe, date: datePicker.date) { _ in }
            //print("Created Menu Item on \(mi.date)")
            // Add ingredients to grocery list
            for ingredient in self.recipe.ingredients {
                //let gi = GroceryListItem(id:4, name: ingredient.name, measurement: ingredient.measurement, quantity: ingredient.quantity, isPurchased: false)
                //print ("Added grocery list item \(gi.name)")
                self.mealPrepManiaAPI.addGroceryListItem(ingredient.name, quantity: ingredient.quantity, measurement: ingredient.measurement) { _ in }
            }
        }))

        ac.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        presentViewController(ac, animated: true, completion: nil)
    }
    
    @IBAction func deleteRecipe(sender: AnyObject) {
        mealPrepManiaAPI.deleteRecipe(self.recipe.id)
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        // Title
        if textField.isEqual(self.recipeTitleTextField) {
            self.recipe.title = textField.text!
        }
        // Ingredients
        else if textField.tag < 1000 {
            let ingredient = self.recipe.ingredients[textField.tag / 10]
            if textField.tag % 10 == 1 {
                ingredient.quantity = floatFormatter.numberFromString(textField.text!) as! Float
            }
            else if textField.tag % 10 == 2 {
                ingredient.measurement = textField.text!
            }
            else if textField.tag % 10 == 3 {
                ingredient.name = textField.text!
            }
        }
        //Directions
        else {
            let direction = self.recipe.directions[textField.tag - 1000]
            direction.text = textField.text!
        }
        self.updateRecipe()
    }
    
    func updateRecipe(){
        self.mealPrepManiaAPI.updateRecipe(recipe){//self.recipe.id, title: self.recipe.title, ingredients: self.recipe.ingredients, directions: self.recipe.directions) {
            (recipe)->Void in
            self.recipe = recipe
            dispatch_async(dispatch_get_main_queue(), { self.tableView.reloadData() })
        }
    }
    
    func dateSelected(datePicker:UIDatePicker){
        let date = datePicker.date
        myTextField.text = dateFormatter.stringFromDate(date)
    }
    
    @IBAction func addIngredient(sender: AnyObject) {
        let i = Ingredient(id: 1, name: "", measurement: "cups", quantity: 1.0)
        self.recipe.ingredients.append(i)
        self.tableView.reloadData()
    }
    
    @IBAction func addDirection(sender: AnyObject) {
        let d = Direction(id: 1, text: "")
        self.recipe.directions.append(d)
        self.tableView.reloadData()
    }
    
}