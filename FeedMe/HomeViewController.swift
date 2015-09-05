//
//  HomeViewController.swift
//  FeedMe
//
//  Created by Jordan Brown on 9/4/15.
//  Copyright (c) 2015 woosufjordaline. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    var foodImage : UIImage? = nil;
    var localUser : User = User();
    var items: [String] = []
    var bgColor = UIColor(red: 253/255.0, green: 251/255.0, blue: 243/255.0, alpha: 255/255.0)
    
    @IBOutlet var textField : UITextField!
    @IBOutlet var tableView: UITableView!
    

   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Handle the text field’s user input through delegate callbacks.
        textField.delegate = self
        var tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismissKeyboard")
        view.addGestureRecognizer(tap)
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.backgroundColor = bgColor
    }
    
    func filterList() { // should probably be called sort and not filter
        self.items.sort() { $0 < $1 }
        self.items = self.items.map({self.firstCharacterUppercaseString($0)})
        self.tableView.reloadData(); // notify the table view the data has changed
    }
    
    override func viewDidAppear(animated: Bool) {
        if (FBSDKAccessToken.currentAccessToken() == nil) {
            self.displayModal()
        }
        self.getLocalUser()
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
                self.items = server.getAllIngredients(self.localUser)
                self.filterList()
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
        var captureScreen = CapturePhotoViewController()
        captureScreen.view.backgroundColor = UIColor(red: 247/255.0, green: 237/255.0, blue: 206/255.0, alpha: 1.0)
        self.presentViewController(captureScreen, animated: true, completion: nil)
        
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
    
    func firstCharacterUppercaseString(string: String) -> String {
        var str = string as NSString
        let firstUppercaseCharacter = str.substringToIndex(1).uppercaseString
        let firstUppercaseCharacterString = str.stringByReplacingCharactersInRange(NSMakeRange(0, 1), withString: firstUppercaseCharacter)
        return firstUppercaseCharacterString
    }
    
    // MARK: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        // Hide the keyboard.
        items.append(self.firstCharacterUppercaseString(textField.text))
        if (textField.text != "") {
            var server = Server()
            server.submitIngredients(localUser, ingredients: [textField.text])
        }
        textField.text = ""
        textField.resignFirstResponder()
        self.filterList()
        return true
    }
    func dismissKeyboard(){
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
    
    // MARK: uitableview stuf
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        
        cell.textLabel?.text = self.items[indexPath.row]
        cell.backgroundColor = bgColor
        cell.textLabel?.font = UIFont(name: "GillSans", size: 20)
        cell.textLabel?.textColor = UIColor(red: 216/255.0, green: 140/255.0, blue: 105/255.0, alpha: 1.0)
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            var server = Server()
            server.deleteIngredient(self.localUser, ingredient: items[indexPath.row])
            items.removeAtIndex(indexPath.row)
            self.tableView.reloadData()
            self.tableView.editing = false
        }
    }

}
