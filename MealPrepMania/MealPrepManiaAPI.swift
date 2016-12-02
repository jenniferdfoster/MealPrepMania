//
//  MealPrepManiaAPI.swift
//  MealPrepMania
//
//  Created by Jennifer Foster on 11/27/16.
//  Copyright © 2016 Jennifer Foster. All rights reserved.
//

import Foundation

class MealPrepManiaAPI {
    private let baseURLString = "https://django-workspace-taylorfoster.c9users.io"
//    private let baseURLString = "https://thawing-eyrie-74516.herokuapp.com"
    let dateFormatter = NSDateFormatter()
    
    let session: NSURLSession = {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        return NSURLSession(configuration: config)
    }()
    
    //Recipes API
    func fetchAllRecipes(completion completion: ([Recipe]) -> Void) {
        let url = NSURL(string: "\(baseURLString)/recipes/")!
        let request = NSURLRequest(URL: url)
        let task = session.dataTaskWithRequest(request) {
            (data, response, error) -> Void in
            
            if let recipes = self.processAllRecipesRequest(data: data, error: error) {
                completion(recipes)
            }
        }
        task.resume()
    }
    
    func processAllRecipesRequest(data data: NSData?, error: NSError?) -> [Recipe]? {
        guard let jsonData = data else {
            return nil
        }
        do {
//            let feedStr = String.init(data: jsonData, encoding: NSUTF8StringEncoding)
//            print(feedStr?.characters)
            let jsonObject: AnyObject = try NSJSONSerialization.JSONObjectWithData(jsonData, options: [])
            guard let
                jsonDictionary = jsonObject as? [[NSObject:AnyObject]]
                else {
                    return nil
            }
            var recipes = [Recipe]()
            for recipeDictionary in jsonDictionary {
                let recipe = recipeFromDict(recipeDictionary)
                recipes.append(recipe)
            }
//            print(recipes)
            return recipes
        }
        catch let error {
            print(error)
            return nil
        }
    }
    
    func addRecipe(completion: (Recipe) -> Void) {
        let url = NSURL(string: "\(baseURLString)/recipes/")!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        let task = session.dataTaskWithRequest(request) {
            (data, response, error) -> Void in
            
            if let recipe = self.processUpdateRecipeRequest(data: data, error: error) {
                completion(recipe)
            }
        }
        task.resume()
    }
    
    func updateRecipe(recipe: Recipe, completion: (Recipe) -> Void) {
        let url = NSURL(string: "\(baseURLString)/recipes/\(recipe.id)")!
        let jsonDict = recipeToDict(recipe)
        do {
            let jsonData = try NSJSONSerialization.dataWithJSONObject(jsonDict, options: [])
            let request = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "POST"
            request.HTTPBody = jsonData
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            let task = session.dataTaskWithRequest(request) {
                (data, response, error) -> Void in
                
                if let recipe = self.processUpdateRecipeRequest(data: data, error: error) {
                    completion(recipe)
                }
            }
            task.resume()
        }
        catch let error {
            print(error)
        }
    }
    
    func processUpdateRecipeRequest(data data: NSData?, error: NSError?) -> Recipe? {
        guard let jsonData = data else {
            return nil
        }
        do {
            let feedStr = String.init(data: jsonData, encoding: NSUTF8StringEncoding)
            print(feedStr?.characters)
            let jsonObject: AnyObject = try NSJSONSerialization.JSONObjectWithData(jsonData, options: [])
            
            guard let
                jsonDictionary = jsonObject as? [NSObject:AnyObject]
                else {
                    return nil
            }
            let recipe = recipeFromDict(jsonDictionary)
            return recipe
        }
        catch let error {
            print(error)
            return nil
        }
    }

    func deleteRecipe(id: Int) {
        let url = NSURL(string: "\(baseURLString)/recipes/\(id)")!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "DELETE"
        let task = session.dataTaskWithRequest(request) {
            (data, response, error) -> Void in
            guard data != nil else {
                print("Error: did not receive data")
                return
            }
        }
        task.resume()
    }

    // Grocery List API
    func fetchGroceryList(completion completion: ([GroceryListItem]) -> Void) {
        let url = NSURL(string: "\(baseURLString)/groceryList/")!
        let request = NSURLRequest(URL: url)
        let task = session.dataTaskWithRequest(request) {
            (data, response, error) -> Void in
            
            if let list = self.processGroceryListRequest(data: data, error: error) {
                completion(list)
            }
        }
        task.resume()
    }
    
    func processGroceryListRequest(data data: NSData?, error: NSError?) -> [GroceryListItem]? {
        guard let jsonData = data else {
            return nil
        }
        do {
            let jsonObject: AnyObject = try NSJSONSerialization.JSONObjectWithData(jsonData, options: [])
            guard let
                jsonDictionary = jsonObject as? [[NSObject:AnyObject]]
                else {
                    return nil
            }
            var list = [GroceryListItem]()
            for listDictionary in jsonDictionary {
                list.append(GroceryListItem(id: (listDictionary["id"] as? Int)!,
                    name: (listDictionary["name"] as? String)!,
                    measurement: (listDictionary["measurement"] as? String)!,
                    quantity: (listDictionary["quantity"] as? Float)!,
                    isPurchased: (listDictionary["isPurchased"] as? Bool)!))
            }
            return list
        }
        catch let error {
            print(error)
            return nil
        }
    }

    func addGroceryListItem(name: String = "sugar", quantity: Float = 1.0, measurement: String = "cup", completion: (GroceryListItem) -> Void) {
        let url = NSURL(string: "\(baseURLString)/groceryList/")!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        let task = session.dataTaskWithRequest(request) {
            (data, response, error) -> Void in
            
            //was process Add
            if let item = self.processUpdateGroceryListRequest(data: data, error: error) {
                self.updateGroceryListItem(item.id, name: name, quantity: quantity, measurement: measurement, isPurchased: false, completion: completion)
                //completion(item)
            }
        }
        task.resume()
    }
    
    func updateGroceryListItem(id: Int, name: String, quantity: Float, measurement: String, isPurchased: Bool, completion: (GroceryListItem) -> Void) {
        let url = NSURL(string: "\(baseURLString)/groceryList/\(id)")!
        print(name)
        print(isPurchased)
        let jsonDict = ["name": name,
                        "measurement": measurement,
                        "quantity": quantity,
                        "isPurchased": isPurchased]
        
          
        do {
            let jsonData = try NSJSONSerialization.dataWithJSONObject(jsonDict, options: [])
            let request = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "POST"
            request.HTTPBody = jsonData
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            let task = session.dataTaskWithRequest(request) {
                (data, response, error) -> Void in
            
                if let item = self.processUpdateGroceryListRequest(data: data, error: error) {
                    completion(item)
                }
            }
            task.resume()
        }
        catch let error {
            print(error)
        }
    }
    
    func processUpdateGroceryListRequest(data data: NSData?, error: NSError?) -> GroceryListItem? {
        guard let jsonData = data else {
            return nil
        }
        do {
            
                        let feedStr = String.init(data: jsonData, encoding: NSUTF8StringEncoding)
                        print(feedStr?.characters)
            let jsonObject: AnyObject = try NSJSONSerialization.JSONObjectWithData(jsonData, options: [])
            
            guard let
                jsonDictionary = jsonObject as? [NSObject:AnyObject]
                else {
                    return nil
            }
            
            let item = GroceryListItem(id: (jsonDictionary["id"] as? Int)!,
                                       name: (jsonDictionary["name"] as? String)!,
                                       measurement: (jsonDictionary["measurement"] as? String)!,
                                       quantity: (jsonDictionary["quantity"] as? Float)!,
                                       isPurchased: (jsonDictionary["isPurchased"] as? Bool)!)
            return item
        }
        catch let error {
            print(error)
            return nil
        }
    }
    
    func processAddGroceryListItemRequest(data data: NSData?, error: NSError?) -> GroceryListItem? {
        guard let jsonData = data else {
            return nil
        }
        do {
//            let feedStr = String.init(data: jsonData, encoding: NSUTF8StringEncoding)
//            print(feedStr?.characters)
            let jsonObject: AnyObject = try NSJSONSerialization.JSONObjectWithData(jsonData, options: [])
            
            guard let
                jsonDictionary = jsonObject as? [NSObject:AnyObject]
                else {
                    return nil
            }
            let item = GroceryListItem(id: (jsonDictionary["id"] as? Int)!,
                                       name: (jsonDictionary["name"] as? String)!,
                                       measurement: (jsonDictionary["measurement"] as? String)!,
                                       quantity: (jsonDictionary["quantity"] as? Float)!,
                                       isPurchased: (jsonDictionary["isPurchased"] as? Bool)!)
            return item
        }
        catch let error {
            print(error)
            return nil
        }
    }

    func deleteGroceryItem(id: Int, completion: () -> Void) {
        let url = NSURL(string: "\(baseURLString)/groceryList/\(id)")!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "DELETE"
        let task = session.dataTaskWithRequest(request) {
            (data, response, error) -> Void in
            guard data != nil else {
                print("Error: did not receive data")
                return
            }
            completion()
        }
        task.resume()
    }
    
    // Menu Items API
    func fetchMenu(completion completion: ([MenuItem]) -> Void) {
        let url = NSURL(string: "\(baseURLString)/menu/")!
        let request = NSURLRequest(URL: url)
        let task = session.dataTaskWithRequest(request) {
            (data, response, error) -> Void in
            
            if let list = self.processMenuRequest(data: data, error: error) {
                completion(list)
            }
        }
        task.resume()
    }
    
    func processMenuRequest(data data: NSData?, error: NSError?) -> [MenuItem]? {
        guard let jsonData = data else {
            return nil
        }
        do {
            let jsonObject: AnyObject = try NSJSONSerialization.JSONObjectWithData(jsonData, options: [])
            guard let
                jsonDictionary = jsonObject as? [[NSObject:AnyObject]]
                else {
                    return nil
            }
            
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            var list = [MenuItem]()
            for listDictionary in jsonDictionary {
                print(listDictionary)
                let recipeArray = listDictionary["recipe"] as! [[NSObject: AnyObject]]
                let r = recipeFromDict(recipeArray[0] as NSDictionary)
                let date = dateFormatter.dateFromString((listDictionary["date"] as? String)!)
                list.append(MenuItem(id: (listDictionary["id"] as? Int)!, recipe: r, date: date!))
            }
            return list
        }
        catch let error {
            print(error)
            return nil
        }
    }
    
    func addMenuItem(recipe: Recipe, date: NSDate = NSDate(), completion: (MenuItem) -> Void) {
        let url = NSURL(string: "\(baseURLString)/menu/")!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        let task = session.dataTaskWithRequest(request) {
            (data, response, error) -> Void in
            
            if let item = self.processUpdateMenuRequest(data: data, error: error) {
                self.updateMenuItem(item.id, recipe: recipe, date: date, completion: completion)
                //completion(item)
            }
        }
        task.resume()
    }
    
    func updateMenuItem(id: Int, recipe: Recipe, date: NSDate, completion: (MenuItem) -> Void) {
        do {
            let url = NSURL(string: "\(baseURLString)/menu/\(id)")!
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            let recipesArr = NSMutableArray()
            //recipesArr.addObject(recipe.id)
            recipesArr.addObject(recipeToDict(recipe))
            let jsonDict = ["date": dateFormatter.stringFromDate(date),
                            "recipe": recipesArr]
            let jsonData = try NSJSONSerialization.dataWithJSONObject(jsonDict, options: [])
            let request = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "POST"
            request.HTTPBody = jsonData
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            let task = session.dataTaskWithRequest(request) {
                (data, response, error) -> Void in
                
                if let item = self.processUpdateMenuRequest(data: data, error: error) {
                    completion(item)
                }
            }
            task.resume()
        }
        catch let error {
            print(error)
        }
    }
    
    func processUpdateMenuRequest(data data: NSData?, error: NSError?) -> MenuItem? {
        guard let jsonData = data else {
            return nil
        }
        do {
            
            let feedStr = String.init(data: jsonData, encoding: NSUTF8StringEncoding)
            print(feedStr?.characters)
            let jsonObject: AnyObject = try NSJSONSerialization.JSONObjectWithData(jsonData, options: [])
            
            guard let
                jsonDictionary = jsonObject as? [NSObject:AnyObject]
                else {
                    return nil
            }
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
            let recipeDictionary = jsonDictionary["recipe"] as? [NSObject: AnyObject]
            let recipe = self.recipeFromDict(recipeDictionary!)
            let item = MenuItem(id: (jsonDictionary["id"] as? Int)!,
                                recipe: recipe,
                                date: dateFormatter.dateFromString((jsonDictionary["date"] as? String)!)!)
            return item
        }
        catch let error {
            print(error)
            return nil
        }
    }

    func deleteMenuItem(id: Int) {
        let url = NSURL(string: "\(baseURLString)/menu/\(id)")!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "DELETE"
        let task = session.dataTaskWithRequest(request) {
            (data, response, error) -> Void in
            guard data != nil else {
                print("Error: did not receive data")
                return
            }
        }
        task.resume()
    }
    
    // Helpers
    func recipeToDict(recipe: Recipe) -> NSDictionary {
        let ingredientsList = NSMutableArray()
        for ingredient in recipe.ingredients {
            let ingredientsDict = NSMutableDictionary()
            ingredientsDict["id"] = ingredient.id
            ingredientsDict["name"] = ingredient.name
            ingredientsDict["measurement"] = ingredient.measurement
            ingredientsDict["quantity"] = ingredient.quantity
            ingredientsList.addObject(ingredientsDict)
        }
        let directionsList = NSMutableArray()
        for direction in recipe.directions {
            let directionsDict = NSMutableDictionary()
            directionsDict["id"] = direction.id
            directionsDict["text"] = direction.text
            directionsList.addObject(directionsDict)
        }
        
        let jsonDict = ["id": recipe.id,
                        "title": recipe.title,
                        "ingredients": ingredientsList,
                        "directions": directionsList]
        return jsonDict
    }
    
    func recipeFromDict(recipeDictionary: NSDictionary) -> Recipe {
        let recipe = Recipe(id: (recipeDictionary["id"] as? Int)!,
                            title: (recipeDictionary["title"] as? String)!)
        let ingredientsDict = recipeDictionary["ingredients"] as? [[NSObject:AnyObject]]
        for ingredient in ingredientsDict! {
            let i = Ingredient(id: (ingredient["id"] as? Int)!,
                               name: (ingredient["name"] as? String)!,
                               measurement: (ingredient["measurement"] as? String)!,
                               quantity: (ingredient["quantity"] as? Float)!)
            recipe.ingredients.append(i)
        }
        let directionsDict = recipeDictionary["directions"] as? [[NSObject: AnyObject]]
        for direction in directionsDict! {
            let d = Direction(id: (direction["id"] as? Int)!,
                              text: (direction["text"] as? String)!)
            recipe.directions.append(d)
        }
        return recipe
    }

}