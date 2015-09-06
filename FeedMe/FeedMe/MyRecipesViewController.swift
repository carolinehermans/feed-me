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
    var recipes = [Recipe]()
    
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
    
    func hideInfo() {
        self.foodNameLabel.hidden = true
        self.foodImageView.hidden = true
        self.ingredientFractionLabel.hidden = true
        self.friendInfoLabel.hidden = true
        self.likeButton.hidden = true
        self.dislikeButton.hidden = true
        self.bigBG.hidden = true
        self.smallBG.hidden = true
    }
    func showInfo() {
        self.foodNameLabel.hidden = false
        self.foodImageView.hidden = false
        self.ingredientFractionLabel.hidden = false
        self.friendInfoLabel.hidden = false
        self.likeButton.hidden = false
        self.dislikeButton.hidden = false
        self.bigBG.hidden = false
        self.smallBG.hidden = false
    }
    
    func populateView(recipe: Recipe?) {
        if (recipe == nil) {
            return; // show no more recipes screen
        }
        foodNameLabel.text = recipe!.name
        let url = NSURL(string: recipe!.imageURLString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()))
        let data = NSData(contentsOfURL: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check
        self.foodImageView.image = UIImage(data: data!)
        var totalFoods = recipe!.ingredients.count + recipe!.missingIngredients.count
        var weHave = String(recipe!.ingredients.count)
        self.ingredientFractionLabel.text = "✓ " + String(weHave) + " out of " + String(totalFoods) + " ingredients"
        var server = Server()
        var friends = server.getAllFriends(self.localUser)
        var foods = [String]()
        for friend in friends {
            foods += server.getAllIngredients(friend)
        }
        println(foods)
        
    }
    
    @IBAction func showNextRecipe() {
        self.recipes.removeAtIndex(0)
        self.populateView(self.recipes.first)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        // Handle the text field’s user input through delegate callbacks.
        textField.delegate = self
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        self.view.addGestureRecognizer(tap)
        self.foodNameLabel.adjustsFontSizeToFitWidth = true
        self.hideInfo()
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.getLocalUser()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func getLocalUser() -> Void {
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me/", parameters:nil)
        var user = User()
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            if ((error) != nil) {
                // Process error
                println("Error: \(error)")
                
            }
            else {
                if let fbid = result["id"] as? String {
                    self.localUser.fbid = fbid
                    if let name = result["name"] as? String {
                        self.localUser.name = name
                    }
                }
                var server = Server()
                self.recipes = server.getAllRecipes(self.localUser);
                self.showInfo()
                self.populateView(self.recipes.first)
                
            }
        })
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
