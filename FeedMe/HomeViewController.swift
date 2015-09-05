//
//  HomeViewController.swift
//  FeedMe
//
//  Created by Jordan Brown on 9/4/15.
//  Copyright (c) 2015 woosufjordaline. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    
    var foodImage : UIImage? = nil;
    var localUser : User = User();
    
    @IBOutlet var textField : UITextField!
    

   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Handle the text field’s user input through delegate callbacks.
        textField.delegate = self
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
    }
    
    override func viewDidAppear(animated: Bool) {
        if (FBSDKAccessToken.currentAccessToken() == nil) {
            self.displayModal()
        }
        var user = User()
        user.fbid = "654321"
        user.name = "name"
        var server = Server()
        server.getAllFriends(user)
        //self.getLocalUser()
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
                if (!server.doesUserExist(self.localUser)) {
                    server.createUser(self.localUser);
                } else {
                    println("user exists")
                }
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayModal() {
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("FacebookLoginViewController") as! FacebookLoginViewController
        self.presentViewController(vc, animated: true, completion: nil)
    }
    
    
    @IBAction func showActionSheet(sender: AnyObject) {
        
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(imagePicker, animated: true, completion: nil)
        
        /*
        let optionMenu = UIAlertController(title: "Add Food", message: nil, preferredStyle: .ActionSheet)
        
        let fromCamera = UIAlertAction(title: "From Camera", style: .Default, handler: {
            (alert: UIAlertAction!) -> Void in
            imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
            self.presentViewController(imagePicker, animated: true, completion: nil)
        })
        let fromPhotoRoll = UIAlertAction(title: "From Photo Library", style: .Default, handler: {
           (alert: UIAlertAction!) -> Void in
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            self.presentViewController(imagePicker, animated: true, completion: nil)
        })
        
        optionMenu.addAction(fromCamera)
        optionMenu.addAction(fromPhotoRoll)

        self.presentViewController(optionMenu, animated: true, completion: nil)
        */
    }
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
/*    func textFieldDidEndEditing(textField: UITextField) {
        mealNameLabel.text = textField.text
    }*/

    // MARK: - UIImagePickerControllerDelegate Methods
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            foodImage = pickedImage;
        }
        
        dismissViewControllerAnimated(true, completion: {
            if let image = self.foodImage {
                let vc = self.storyboard?.instantiateViewControllerWithIdentifier("ImageProcessingViewController") as! ImageProcessingViewController
                vc.image = image;
                self.presentViewController(vc, animated: true, completion: nil);
            }
        })
    }
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
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
