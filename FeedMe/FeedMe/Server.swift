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
    
}
