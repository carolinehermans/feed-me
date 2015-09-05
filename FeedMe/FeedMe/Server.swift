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
 
    func nsdataToJSON(data: NSData) -> AnyObject? {
        return NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers, error: nil)
    }
    
    func doesUserExist(user: User) -> Bool {
        let url = NSURL(string: domain + "?action=check_user_exists&f_id=" + (user.fbid as String))
        var data = NSData(contentsOfURL: url!)
        if let json: NSDictionary = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: nil) as? NSDictionary {
            if let val = json["val"] as? NSNumber {
                println(val.integerValue > 0)
                return val.integerValue > 0
            }
        }
        return false;
    }
    
    func createUser(name: NSString, fbid: NSString) -> Bool {
        let url = NSURL(string: domain + "?action=create_user&f_id=" + (fbid as String) + "&name=" + (name as String))
        var data = NSData(contentsOfURL: url!)
        
        if let json: NSDictionary = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: nil) as? NSDictionary {
            if let val = json["val"] as? NSNumber {
                println(val.integerValue > 0)
                return val.integerValue > 0
            }
        }
        return false;
    }
    
    
}
