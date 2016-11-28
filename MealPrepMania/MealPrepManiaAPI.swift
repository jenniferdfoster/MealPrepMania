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
    
    let session: NSURLSession = {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        return NSURLSession(configuration: config)
    }()
    
    func fetchAllRecipes(completion completion: ([Recipe]) -> Void) {
        let url = NSURL(string: "\(baseURLString)/snippets/")!
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
            
            let feedStr = String.init(data: jsonData, encoding: NSUTF8StringEncoding)
            print(feedStr?.characters)
            
            let jsonObject: AnyObject = try NSJSONSerialization.JSONObjectWithData(jsonData, options: [])
            print("jsonObject: \(jsonObject)")
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
            let url = NSURL(string: "\(baseURLString)/snippets?title=\(newTitle)")!
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
        let url = NSURL(string: "\(baseURLString)/snippets/\(id)")!
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