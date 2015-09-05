//
//  ViewController.swift
//  FeedMe
//
//  Created by Jordan Brown on 9/4/15.
//  Copyright (c) 2015 woosufjordaline. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        println("loaded")
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            // User is already logged in, do work such as go to next view controller.
            //self.displayPostLoginController()
           
        }
        else {
            // present modal
        }
        
    }
    
    func displayPostLoginController() {
        var VC1 = self.storyboard?.instantiateViewControllerWithIdentifier("HomeViewController") as HomeViewController
        let navController = UINavigationController(rootViewController: VC1) // Creating a navigation controller with VC1 at the root of the navigation stack.
        self.presentViewController(navController, animated:false, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

