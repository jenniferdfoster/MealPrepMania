//
//  MealPrepManiaAPI.swift
//  MealPrepMania
//
//  Created by Jennifer Foster on 11/27/16.
//  Copyright © 2016 Jennifer Foster. All rights reserved.
//

import Foundation

class MealPrepManiaAPI {
    //private let baseURLString = "https://django-workspace-taylorfoster.c9users.io"
    private let baseURLString = "https://thawing-eyrie-74516.herokuapp.com"
    
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
//            print("jsonObject: \(jsonObject)")
            guard let
                jsonDictionary = jsonObject as? [[NSObject:AnyObject]]
                else {
                    return nil
            }
            
            var recipes = [Recipe]()
            for recipeDictionary in jsonDictionary {
                recipes.append(Recipe(id: (recipeDictionary["id"] as? Int)!, title: (recipeDictionary["title"] as? String)!))
            }
            print(recipes)
            return recipes
        }
        catch let error {
            print(error)
            return nil
        }
    }
    
    func addRecipe(completion: (Recipe) -> Void) {
        if let newTitle = ("New Recipe").stringByAddingPercentEncodingWithAllowedCharacters(.URLHostAllowedCharacterSet()){
            let url = NSURL(string: "\(baseURLString)/recipes/?title=\(newTitle)")!
            let request = NSMutableURLRequest(URL: url)
            request.HTTPMethod = "POST"
            let task = session.dataTaskWithRequest(request) {
                (data, response, error) -> Void in
                
                if let recipe = self.processAddRecipeRequest(data: data, error: error) {
                    completion(recipe)
                }
            }
            task.resume()
        }
    }
    
    func processAddRecipeRequest(data data: NSData?, error: NSError?) -> Recipe? {
        guard let jsonData = data else {
            return nil
        }
        do {
            let jsonObject: AnyObject = try NSJSONSerialization.JSONObjectWithData(jsonData, options: [])
            
            guard let
                jsonDictionary = jsonObject as? [NSObject:AnyObject]
                else {
                    return nil
            }
            let recipe = Recipe(id: (jsonDictionary["id"] as? Int)!, title: (jsonDictionary["title"] as? String)!)
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
            
            //            let feedStr = String.init(data: jsonData, encoding: NSUTF8StringEncoding)
            //            print(feedStr?.characters)
            
            let jsonObject: AnyObject = try NSJSONSerialization.JSONObjectWithData(jsonData, options: [])
            //            print("jsonObject: \(jsonObject)")
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

    func addGroceryListItem(completion: (GroceryListItem) -> Void) {
        //let url = NSURL(string: "\(baseURLString)/groceryList/?name=\(newName)")!
        let url = NSURL(string: "\(baseURLString)/groceryList/")!
        let request = NSMutableURLRequest(URL: url)
        request.HTTPMethod = "POST"
        let task = session.dataTaskWithRequest(request) {
            (data, response, error) -> Void in
            
            if let item = self.processAddGroceryListItemRequest(data: data, error: error) {
                completion(item)
            }
        }
        task.resume()
    }
    
    func processAddGroceryListItemRequest(data data: NSData?, error: NSError?) -> GroceryListItem? {
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

    func deleteGroceryItem(id: Int) {
        let url = NSURL(string: "\(baseURLString)/groceryList/\(id)")!
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
    
    // Menu Items API
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
}