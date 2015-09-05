//
//  HomeViewController.swift
//  FeedMe
//
//  Created by Jordan Brown on 9/4/15.
//  Copyright (c) 2015 woosufjordaline. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        if (FBSDKAccessToken.currentAccessToken() == nil) {
            self.displayModal();
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayModal() {
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("FacebookLoginViewController") as FacebookLoginViewController
        vc.view.backgroundColor = UIColor.whiteColor();
        self.presentViewController(vc, animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
