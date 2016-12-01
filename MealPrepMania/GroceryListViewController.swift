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
    
    let floatFormatter = NSNumberFormatter()
    let dateFormatter = NSDateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        self.loadGroceryList()
    }
    
    func loadGroceryList() {
        // Get all grocery list items
        mealPrepManiaAPI.fetchGroceryList{
            (allGroceryListItems)->Void in
            self.groceryList = allGroceryListItems
            dispatch_async(dispatch_get_main_queue(), { self.tableView.reloadData() })
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groceryList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("GroceryListItemCell", forIndexPath: indexPath) as! IngredientCell
        
        let groceryItem = self.groceryList[indexPath.row]
    
        cell.quantityTextField.text = floatFormatter.stringFromNumber(groceryItem.quantity)
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
            self.mealPrepManiaAPI.deleteGroceryItem(groceryItem.id) { _ in }
            self.groceryList.removeAtIndex(indexPath.row)
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let groceryItem = self.groceryList[indexPath.row]
        mealPrepManiaAPI.updateGroceryListItem(groceryItem.id, name: groceryItem.name, quantity: groceryItem.quantity, measurement: groceryItem.measurement, isPurchased: !groceryItem.isPurchased) {
                (updatedItem)->Void in
                groceryItem.isPurchased = updatedItem.isPurchased
                dispatch_async(dispatch_get_main_queue(), { self.tableView.reloadData() })
        }
        self.tableView.reloadData()
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        let groceryItem = groceryList[textField.tag / 10]
        if textField.tag % 10 == 1 {
            groceryItem.quantity = floatFormatter.numberFromString(textField.text!) as! Float
        }
        else if textField.tag % 10 == 2 {
            groceryItem.measurement = textField.text!
        }
        else if textField.tag % 10 == 3 {
            groceryItem.name = textField.text!
        }
        mealPrepManiaAPI.updateGroceryListItem(groceryItem.id, name: groceryItem.name, quantity: groceryItem.quantity, measurement: groceryItem.measurement, isPurchased: groceryItem.isPurchased) {
            (updatedItem)->Void in
            groceryItem.isPurchased = updatedItem.isPurchased
            dispatch_async(dispatch_get_main_queue(), { self.tableView.reloadData() })
        }
    }

    @IBAction func addNewItem(sender: AnyObject) {
        mealPrepManiaAPI.addGroceryListItem {
            (newItem)->Void in
            self.groceryList.append(newItem)
            dispatch_async(dispatch_get_main_queue(), { self.tableView.reloadData() })
        }
    }
    
    @IBAction func deleteAllCheckedItems(sender: AnyObject) {
        let title = "Delete All Checked Items"
        let message = "Are you sure you want to delete all purchased items?"
        
        let alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: .ActionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .Cancel,
                                         handler: nil)
        
        let deleteAction = UIAlertAction(title: "Delete",
                                         style: .Destructive,
                                         handler: { (action) -> Void in
                                            for i in 0...self.groceryList.count - 1 {
                                                let item = self.groceryList[i]
                                                if(item.isPurchased) {
                                                    self.mealPrepManiaAPI.deleteGroceryItem(item.id) { _ in
                                                        self.loadGroceryList()
                                                    }
                                                }
                                            }
        })
        
        alertController.addAction(cancelAction)
        alertController.addAction(deleteAction)
        
        presentViewController(alertController, animated: true, completion: nil)
    }
}