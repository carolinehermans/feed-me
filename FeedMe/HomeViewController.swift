//
//  HomeViewController.swift
//  FeedMe
//
//  Created by Jordan Brown on 9/4/15.
//  Copyright (c) 2015 woosufjordaline. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var foodImage : UIImage? = nil;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(animated: Bool) {
        if (FBSDKAccessToken.currentAccessToken() == nil) {
            self.displayModal();
        }
        self.displayModal();
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
