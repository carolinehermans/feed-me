//
//  FoodComHTMLParser.swift
//  FeedMe
//
//  Created by Yousuf Soliman on 9/5/15.
//  Copyright (c) 2015 woosufjordaline. All rights reserved.
//

import UIKit

class FoodComHTMLParser: NSObject {
    
    var html : NSString = "";
    
    init(url: String) {
        println(url)
        
        if let myURL = NSURL(string: url) {
            var error: NSError?
            let html = NSString(contentsOfURL: myURL, encoding: NSUTF8StringEncoding, error: &error)
            
            if let error = error {
                println("Error : \(error)")
            } else {
                println(html)
            }
        } else {
            println("Error: \(url) doesn't seem to be a valid URL")
        }
    }
    
    func getRecipeJSON(source : NSString) {
        var jsonPos = source.rangeOfString("FD.Page.Recipe.init(");
        println("jsonPos: "+String(stringInterpolationSegment: jsonPos.location));
        println(source.substringFromIndex(jsonPos.location))
        if jsonPos.location != NSNotFound {
            println("exists! : " + String(stringInterpolationSegment: jsonPos.location))
            
        }
        
        // alternative: not case sensitive
        if source.lowercaseString.rangeOfString("swift") != nil {
            println("exists")
        }
    }
   
}
