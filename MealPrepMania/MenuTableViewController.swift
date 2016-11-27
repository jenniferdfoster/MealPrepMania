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
        
        let r = Recipe(id: "1", title: "Tasty Cakes")
        let ing = Ingredient(name: "cake", measurement: "tons", quantity: 3.0)
        r.ingredients.append(ing)
        let dir = Direction(id: "1", text: "Make Tasty Cakes")
        let dir2 = Direction(id: "2", text: "Enjoy Tasty Cakes")
        r.directions.append(dir)
        r.directions.append(dir2)
        
        let r2 = Recipe(id: "2", title: "Jelly Beans")
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
        
        let mi = MenuItem(recipe: r, date: NSDate())
        let mi2 = MenuItem(recipe: r2, date: NSDate(timeIntervalSinceNow:60*60*24))
        
        self.menuItems.append(mi)
        self.menuItems.append(mi2)
        
        self.sortMenu()
        
        self.tableView.reloadData()
        
//        mealPrepManiaAPI.fetchAllRecipes{
//            (allRecipes)->Void in
//            self.recipes = allRecipes
//            dispatch_async(dispatch_get_main_queue(), { self.tableView.reloadData() })
//        }
    }
    
    func sortMenu () {
        self.menuItems.sortInPlace({ $0.date.compare($1.date) == NSComparisonResult.OrderedAscending })
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MenuItemCell", forIndexPath: indexPath)
        let menuItem = self.menuItems[indexPath.row]
        cell.textLabel?.text = menuItem.recipe.title
        dateFormatter.dateFormat = "MMM dd"
        cell.detailTextLabel?.text = dateFormatter.stringFromDate(menuItem.date)
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let menuItem = self.menuItems[indexPath.row]
            print("Delete \(menuItem.recipe.title)")
            //TODO: Delete menu item from backend
            self.menuItems.removeAtIndex(indexPath.row)
            self.tableView.reloadData()
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
            // Add recipe to menu on specified date
            menuItem.date = datePicker.date
            //TODO: Save Menu Item to backend
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