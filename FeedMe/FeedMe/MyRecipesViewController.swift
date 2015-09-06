//
//  MyRecipesViewController.swift
//  FeedMe
//
//  Created by Caroline Hermans on 9/5/15.
//  Copyright (c) 2015 woosufjordaline. All rights reserved.
//

import UIKit

private var numberOfCards: UInt = 5
class MyRecipesViewController: UIViewController, UITextFieldDelegate {

    var foodImage : UIImage? = nil;
    var localUser : User = User();
    
    @IBOutlet var textField : UITextField!
    @IBOutlet var recipeView : UIView!
    @IBOutlet var foodNameLabel : UILabel!
    @IBOutlet var prepTimeLabel : UILabel!
    @IBOutlet var foodImageView : UIImageView!
    @IBOutlet var ingredientFractionLabel : UILabel!
    @IBOutlet var friendInfoLabel : UILabel!
    @IBOutlet var likeButton : UIButton!
    @IBOutlet var dislikeButton : UIButton!
    @IBOutlet var bigBG : UIImageView!
    @IBOutlet var smallBG : UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        // Handle the text field’s user input through delegate callbacks.
        textField.delegate = self
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        self.view.addGestureRecognizer(tap)
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
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    func DismissKeyboard(){
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
}
