//
//  RecipeDetailViewController.swift
//  FeedMe
//
//  Created by Jordan Brown on 9/6/15.
//  Copyright (c) 2015 woosufjordaline. All rights reserved.
//

import UIKit

class RecipeDetailViewController: UIViewController {
    
    @IBOutlet var ingredientsTextView : UITextView!
    @IBOutlet var recipeImageView : UIImageView!
    @IBOutlet var recipeNameLabel : UILabel!
    @IBOutlet var recipeInstructionsTextView : UITextView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
