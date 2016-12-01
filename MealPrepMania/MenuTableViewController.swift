//
//  MenuTableViewController.swift
//  MealPrepMania
//
//  Created by Jennifer Foster on 11/27/16.
//  Copyright © 2016 Jennifer Foster. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {
    
    var mealPrepManiaAPI: MealPrepManiaAPI!
    var menuItems: [MenuItem] = [MenuItem]()
    var myTextField: UITextField = UITextField()
    let dateFormatter = NSDateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        // Get all menu items
        mealPrepManiaAPI.fetchMenu{
            (allMenuItems)->Void in
            self.menuItems = allMenuItems
            self.sortMenu()
            dispatch_async(dispatch_get_main_queue(), { self.tableView.reloadData() })
        }
    }
    
    func sortMenu () {
        // Sort Menu Items by date
        self.menuItems.sortInPlace({ $0.date.compare($1.date) == NSComparisonResult.OrderedAscending })
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MenuItemCell", forIndexPath: indexPath) as! MenuItemCell
        let menuItem = self.menuItems[indexPath.row]
        dateFormatter.dateFormat = "MMM"
        cell.recipeLabel.text = menuItem.recipe.title
        cell.monthLabel.text = dateFormatter.stringFromDate(menuItem.date)
        dateFormatter.dateFormat = "dd"
        cell.dayLabel.text = dateFormatter.stringFromDate(menuItem.date)
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let menuItem = self.menuItems[indexPath.row]
            print("Delete \(menuItem.recipe.title)")
            mealPrepManiaAPI.deleteMenuItem(menuItem.id)
            self.menuItems.removeAtIndex(indexPath.row)
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let menuItem = self.menuItems[indexPath.row]
        let datePicker = UIDatePicker()
        
        let ac = UIAlertController(title: "Change Day?", message: nil, preferredStyle: .Alert)
        ac.addTextFieldWithConfigurationHandler({
            (textField) -> Void in
            datePicker.datePickerMode = .Date
            datePicker.addTarget(self, action: #selector(RecipeDetailsViewController.dateSelected(_:)), forControlEvents: UIControlEvents.ValueChanged)
            datePicker.date = menuItem.date
            self.myTextField = textField
            self.dateFormatter.dateStyle = .MediumStyle
            self.myTextField.text = self.dateFormatter.stringFromDate(datePicker.date)
            textField.inputView = datePicker
        })
        ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: {
            alert -> Void in
            menuItem.date = datePicker.date
            self.mealPrepManiaAPI.updateMenuItem(menuItem.id, recipe: menuItem.recipe, date: datePicker.date){
                (updatedItem)->Void in
                dispatch_async(dispatch_get_main_queue(), { self.tableView.reloadData() })
            }
            print("Updated Menu Item to \(menuItem.date)")
            self.sortMenu()
            self.tableView.reloadData()
        }))
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
        presentViewController(ac, animated: true, completion: nil)
    }
    
    func dateSelected(datePicker:UIDatePicker)
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        let date = datePicker.date
        myTextField.text = dateFormatter.stringFromDate(date)
    }
}