//
//  MealPrepManiaAPI.swift
//  MealPrepMania
//
//  Created by Jennifer Foster on 11/27/16.
//  Copyright © 2016 Jennifer Foster. All rights reserved.
//

import Foundation

class MealPrepManiaAPI {
    private let baseURLString = "https://django-workspace-taylorfoster.c9users.io/snippets/?format=json"
    
    let session: NSURLSession = {
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        return NSURLSession(configuration: config)
    }()
    
    func fetchAllRecipes(completion completion: ([Recipe]) -> Void) {
        let url = NSURL(string: "\(baseURLString)")!
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
                recipes.append(Recipe(id: (recipeDictionary["id"] as? String)!, title: (recipeDictionary["title"] as? String)!))
            }
            print("Doing stuff")
            print(recipes)
            return recipes
        }
        catch let error {
            print(error)
            return nil
        }
    }
}