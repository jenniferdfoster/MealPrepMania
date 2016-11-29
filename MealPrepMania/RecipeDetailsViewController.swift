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
    var recipe: Recipe = Recipe(id: 1, title: "boo")
    var myTextField: UITextField = UITextField()
    @IBOutlet var recipeTitleTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Edit Recipe"
        self.recipeTitleTextField.text = self.recipe.title
        self.tableView.estimatedRowHeight = 80
        self.tableView.rowHeight = UITableViewAutomaticDimension
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

            cell.quantityTextField.text = ingredient.quantity.description
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
            //cell.textLabel!.text = recipe.directions[indexPath.row].text
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
    
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        switch indexPath.section {
//        case 0:
//            return
//        case 1:
//            updateDirection(self.recipe.directions[indexPath.row])
//        default:
//            return
//        }
//    }
    
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
            let mi = MenuItem(id: 3, recipe: self.recipe, date: datePicker.date)
            //TODO: Save Menu Item to backend
            print("Created Menu Item on \(mi.date)")
            // Add ingredients to grocery list
            for ingredient in self.recipe.ingredients {
                let gi = GroceryListItem(id:4, name: ingredient.name, measurement: ingredient.measurement, quantity: ingredient.quantity, isPurchased: false)
                print ("Added grocery list item \(gi.name)")
            }
        }))

        ac.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        presentViewController(ac, animated: true, completion: nil)
    }
    
    func updateDirection(direction: Direction) {
        
        let title = "Edit Direction"
        let message = ""
        
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .Cancel,
                                         handler: nil)
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: UIAlertActionStyle.Default,
                                       handler: {
                                        alert -> Void in
                                        
                                        let descriptionTextField = alertController.textFields![0] as UITextField
                                        direction.text = descriptionTextField.text!
                                        self.tableView.reloadData()
                                        //TODO: Save to backend
                                        
                                        
//                                        self.trelloAPI.updateRecipe(card.id, name: titleTextField.text!, description: descriptionTextField.text!) {
//                                            (updatedCard)->Void in
//                                            card.name = updatedCard.name
//                                            card.description = updatedCard.description
//                                            dispatch_async(dispatch_get_main_queue(), { self.tableView.reloadData() })
//                                        }
        })
        
        alertController.addTextFieldWithConfigurationHandler {
            (textField : UITextField!) -> Void in
            textField.placeholder = "Enter Directions Text"
            textField.text = direction.text
        }
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }

    
    @IBAction func deleteRecipe(sender: AnyObject) {
        mealPrepManiaAPI.deleteRecipe(self.recipe.id)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        // Title
        if textField.isEqual(self.recipeTitleTextField) {
            self.recipe.title = textField.text!
        }
        // Ingredients
        if textField.tag < 1000 {
            let ingredient = self.recipe.ingredients[textField.tag / 10]
            if textField.tag % 10 == 1 {
                let nf = NSNumberFormatter()
                ingredient.quantity = nf.numberFromString(textField.text!) as! Float
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
            return
        }
    }
    
    func dateSelected(datePicker:UIDatePicker)
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        let date = datePicker.date
        myTextField.text = dateFormatter.stringFromDate(date)
    }
}