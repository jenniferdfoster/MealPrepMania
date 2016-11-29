//
//  GroceryListViewController.swift
//  MealPrepMania
//
//  Created by Jennifer Foster on 11/27/16.
//  Copyright © 2016 Jennifer Foster. All rights reserved.
//

import UIKit

class GroceryListViewController: UITableViewController, UITextFieldDelegate {
    
    var mealPrepManiaAPI: MealPrepManiaAPI!
    var groceryList: [GroceryListItem] = [GroceryListItem]()
    let dateFormatter = NSDateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
        for i in r.ingredients {
            groceryList.append(GroceryListItem(id: 1, name: i.name, measurement: i.measurement, quantity: i.quantity, isPurchased: false))
        }
        
        for i in r2.ingredients {
            groceryList.append(GroceryListItem(id: 2, name: i.name, measurement: i.measurement, quantity: i.quantity, isPurchased: false))
        }
        
        self.tableView.reloadData()
        
        //        mealPrepManiaAPI.fetchAllRecipes{
        //            (allRecipes)->Void in
        //            self.recipes = allRecipes
        //            dispatch_async(dispatch_get_main_queue(), { self.tableView.reloadData() })
        //        }
    }
    
//    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
//        return 2
//    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        var numRows = 0
//        for gi in groceryList {
//            if section == 0 && !gi.isPurchased {
//                numRows += 1
//            }
//            if section == 1 && gi.isPurchased {
//                numRows += 1
//            }
//        }
//        return numRows
        return groceryList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("GroceryListItemCell", forIndexPath: indexPath) as! IngredientCell
        
        let groceryItem = self.groceryList[indexPath.row]
    
        cell.quantityTextField.text = groceryItem.quantity.description
        cell.quantityTextField.tag = (indexPath.row * 10) + 1
        cell.quantityTextField.keyboardType = .DecimalPad
        cell.quantityTextField.delegate = self
    
        cell.measurementTextField.text = groceryItem.measurement
        cell.measurementTextField.tag = (indexPath.row * 10) + 2
        cell.measurementTextField.delegate = self
    
        cell.nameTextField.textColor = UIColor.darkTextColor()
        cell.nameTextField.text = groceryItem.name
        cell.nameTextField.tag = (indexPath.row * 10) + 3
        cell.nameTextField.delegate = self
    
        if groceryItem.isPurchased {
            cell.accessoryType = .Checkmark
        }
        else {
            cell.accessoryType = .None
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let groceryItem = self.groceryList[indexPath.row]
            print("Delete \(groceryItem.name)")
            //TODO: Delete grocery list item from backend
            self.groceryList.removeAtIndex(indexPath.row)
            self.tableView.reloadData()
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let groceryItem = self.groceryList[indexPath.row]
        groceryItem.isPurchased = !groceryItem.isPurchased
        self.tableView.reloadData()
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        // Ingredients
        if textField.tag < 1000 {
            let ingredient = groceryList[textField.tag / 10]
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
            return
        }
    }

    @IBAction func addNewItem(sender: AnyObject) {
        
    }
}