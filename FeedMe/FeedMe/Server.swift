//
//  Server.swift
//  FeedMe
//
//  Created by Jordan Brown on 9/5/15.
//  Copyright (c) 2015 woosufjordaline. All rights reserved.
//

import UIKit

class Server: NSObject {
    var domain = "http://ec2-52-10-65-63.us-west-2.compute.amazonaws.com/api.php"
    var friends = [Int]();
    
    func doesUserExist(user: User) -> Bool {
        let url = NSURL(string: domain + "?action=check_user_exists&f_id=" + (user.fbid as String))
        var data = NSData(contentsOfURL: url!)
        if let json: NSDictionary = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: nil) as? NSDictionary {
            if let val = json["val"] as? NSNumber {
                return val.integerValue > 0
            }
        }
        return false;
    }
    
    func createUser(user: User) -> Bool {
        let urlString = domain + "?action=create_user&f_id=" + (user.fbid as String) + "&name=" + (user.name.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)! as String)
        let url = NSURL(string: urlString)
        var data = NSData(contentsOfURL: url!)
        if let json: NSDictionary = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: nil) as? NSDictionary {
            if let val = json["val"] as? NSNumber {
                return val.integerValue > 0
            }
        }
        return false;
    }
    
    func createFriendship(user1: User, user2: User) -> Bool {
        let urlString = domain + "?action=create_relationship&f_id1=" + (user1.fbid as String) + "&f_id2" + (user2.fbid as String)
        let url = NSURL(string: urlString)
        var data = NSData(contentsOfURL: url!)
        if let json: NSDictionary = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: nil) as? NSDictionary {
            if let val = json["val"] as? NSNumber {
                return val.integerValue > 0
            }
        }
        return false;
    }
    
    func getAllFriends(user: User) -> [User] {
        println("getting friends")
        let urlString = domain + "?action=get_all_relationships&f_id=" + (user.fbid as String)
        println(urlString)
        let url = NSURL(string: urlString)
        var data = NSData(contentsOfURL: url!)
        if let json: NSDictionary = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: nil) as? NSDictionary {
            println(json)
            if let val = json["val"] as? NSArray {
                // This is na array of fbids
                // You have to generate local user's friends and check here to see which names match which ids 
                // so we can create the users
                println(val[0]);
                
            }
        }
        
        return [];
    }
    
    func getNameForID(id: String) -> String {
        let urlString = domain + "?action=get_name&f_id=" + (id as String)
        println(urlString)
        let url = NSURL(string: urlString)
        var data = NSData(contentsOfURL: url!)
        if let json: NSDictionary = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: nil) as? NSDictionary {
            println(json)
            if let val = json["val"] as? String {
                // This is na array of fbids
                // You have to generate local user's friends and check here to see which names match which ids
                // so we can create the users
                return val
                
            }
        }
        return ""
    }
    
    func submitIngredients(user: User, ingredients: [String]) -> Bool {
        var ingredientString = ""
        for ingredient in ingredients {
            ingredientString += ingredient.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
            if (ingredient != ingredients.last) {
                ingredientString += ","
            }
        }
        
        let urlString = domain + "?action=submit_ingredients&f_id=" + (user.fbid as String) + "&ingredients=" + (ingredientString as String)
        
        let url = NSURL(string: urlString)
        var data = NSData(contentsOfURL: url!)
        if let json: NSDictionary = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: nil) as? NSDictionary {
            if let val = json["val"] as? NSNumber {
                return val.integerValue > 0
            }
        }
        return false
    }
    
    func whoHasIngredient(ingredient: String) -> [String] {
        let urlString = domain + "?action=who_has_ingredient&ingredient=" + ingredient.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        let url = NSURL(string: urlString)
        var data = NSData(contentsOfURL: url!)
        if let json: NSDictionary = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: nil) as? NSDictionary {
            if let val = json["val"] as? NSArray {
                var names = [String]()
                for id in val {
                    names.append(self.getNameForID(id as! String))
                }
                return names
            }
        }
        return []
    }
    
    func getAllIngredients(user: User) -> [String] {
        let urlString = domain + "?action=get_all_ingredients&f_id=" + (user.fbid as String)
        let url = NSURL(string: urlString)
        var data = NSData(contentsOfURL: url!)
        if let json: NSDictionary = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: nil) as? NSDictionary {
            if let val = json["val"] as? String {
                return val.componentsSeparatedByString(",")
            }
        }
        return []
    }
    
    func deleteIngredient(user: User, ingredient: String) -> Bool {
        let urlString = domain + "?action=delete_ingredient&ingredient=" + ingredient.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)! + "&f_id=" + (user.fbid as String)

        let url = NSURL(string: urlString)
        var data = NSData(contentsOfURL: url!)
        if let json: NSDictionary = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: nil) as? NSDictionary {
            if let val = json["val"] as? NSNumber {
                return val.integerValue > 0
            }
        }
        return false
    }
    
    func getAllRecipes(user: User) -> [Recipe] {
        let urlString = domain + "?action=get_recipes&f_id=" + (user.fbid as String)
        let url = NSURL(string: urlString)
        var data = NSData(contentsOfURL: url!)
        if let json: NSDictionary = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: nil) as? NSDictionary {
            if var val = json["val"] as? String {
                var recipes = [Recipe]()
                val = val.stringByReplacingOccurrencesOfString("[", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                val = val.stringByReplacingOccurrencesOfString("]", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
                var strings = val.componentsSeparatedByString("+=+")
                for string in strings {
                    var fields = string.componentsSeparatedByString(",")
                    var recipe = Recipe()
                    recipe.name = fields[0]
                    recipe.urlString = fields[1]
                    recipe.imageURLString = fields[2]
                    var foodStrings = fields[3].componentsSeparatedByString("+")
                    for foodString in foodStrings {
                        var food = Food()
                        food.name = foodString
                        recipe.ingredients.append(food)
                    }
                    var missingFoods = fields[4].componentsSeparatedByString("+")
                    for foodString in missingFoods {
                        var food = Food()
                        food.name = foodString
                        recipe.missingIngredients.append(food)
                    }
                    recipes.append(recipe)
                }
                return recipes
            }
        }
        return []
    }
    
    func uploadImage(image: UIImage) {
        var dataString = UIImageJPEGRepresentation(image, 0.5).base64EncodedStringWithOptions(nil)
        var url: NSURL = NSURL(string: "http://ec2-52-20-44-70.compute-1.amazonaws.com:8000/upload")!
        var request:NSMutableURLRequest = NSMutableURLRequest(URL:url)
        var bodyData = dataString
        request.HTTPMethod = "POST"
        request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding);
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue())
            {
                
                (response, data, error) in
                
                var datastring = NSString(data: data, encoding: NSUTF8StringEncoding)
                println("data:")
                println(datastring)
                NSUserDefaults.standardUserDefaults().setObject(datastring, forKey: "box")
                NSUserDefaults.standardUserDefaults().synchronize()
                
        }
        
    }
    
}
