//
//  ImageProcessingViewController.swift
//  FeedMe
//
//  Created by Jordan Brown on 9/5/15.
//  Copyright (c) 2015 woosufjordaline. All rights reserved.
//

import UIKit

class ImageProcessingViewController: UIViewController {

    @IBOutlet var imageView : UIImageView!
    var localUser : User = User();
    var image : UIImage!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("here")
        self.imageView.image = self.image;
        // Do any additional setup after loading the view.
        self.imageView.image = self.getImageFromString()
        let doneButton = UIButton()
        doneButton.setTitle("Done", forState: .Normal)
        doneButton.setTitleColor(UIColor.blueColor(), forState: .Normal)
        doneButton.frame = CGRectMake(self.view.frame.width - 60, 0, 50, 50)
        doneButton.addTarget(self, action: "doneClicked", forControlEvents: .TouchUpInside)
        self.view.addSubview(doneButton)
    }
    func getLocalUser(objects: [String]) -> Void {
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
                server.submitIngredients(self.localUser, ingredients: objects)
                
            }
        })
    }

    func getImageFromString() -> UIImage? {
        var imageString: AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey("yeongwoo")
        var splitString = (imageString?.componentsSeparatedByString("^##^") as! [String])
        imageString = splitString[1]
        var objectString = splitString[0]
        var objects = objectString.componentsSeparatedByString(";")
        self.getLocalUser(objects)
        var str = "data:image/jpg;base64,"
        str = str.stringByAppendingString((imageString as! String))
        var imageData = NSData(contentsOfURL: NSURL(string: str)!)
        return UIImage(data: imageData!)
    }
    
    func doneClicked() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func drawBoxes() {
        var drawInstructions = (NSUserDefaults.standardUserDefaults().objectForKey("box") as! String).componentsSeparatedByString(";")
        for drawInstruction in drawInstructions {
            var coordinateLabelPair = drawInstruction.componentsSeparatedByString("-")
            if (coordinateLabelPair.count < 2) {
                continue;
            }
            var coords = (coordinateLabelPair[0] as String).componentsSeparatedByString(",")
            var object = coordinateLabelPair[1]
            if (object != "unknown") {
                self.drawCustomImage(CGPointMake(CGFloat((coords[0] as NSString).floatValue), CGFloat((coords[1] as NSString).floatValue)), bottomRight: CGPointMake(CGFloat((coords[2] as NSString).floatValue), CGFloat((coords[3] as NSString).floatValue)))
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkDefaults() -> Bool {
        if (NSUserDefaults.standardUserDefaults().objectForKey("yeongwoo") == nil) {
            self.checkDefaults()
        }
        return true;
    }
    @IBAction func dismiss() {
        self.dismissViewControllerAnimated(true, completion: nil);
    }
    
    func drawCustomImage(topLeft : CGPoint, bottomRight : CGPoint) {
        var size = CGSizeMake(abs(topLeft.x - bottomRight.x), abs(topLeft.y - bottomRight.y))
        // Setup our context
        let bounds = CGRect(origin: CGPoint.zeroPoint, size: size)
        let opaque = false
        let scale: CGFloat = 0
        UIGraphicsBeginImageContextWithOptions(size, opaque, scale)
        let context = UIGraphicsGetCurrentContext()
        
        // Setup complete, do drawing here
        CGContextSetStrokeColorWithColor(context, UIColor.redColor().CGColor)
        CGContextSetLineWidth(context, 2.0)
        
        CGContextStrokeRect(context, bounds)
        
        CGContextBeginPath(context)
        CGContextMoveToPoint(context, CGRectGetMinX(bounds), CGRectGetMinY(bounds))
        
        CGContextStrokePath(context)
        
        // Drawing complete, retrieve the finished image and cleanup
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        var imageView = UIImageView(frame: CGRect(origin: topLeft, size: size))
        self.imageView.addSubview(imageView)
        println(self.imageView.frame);
        imageView.image = image;
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
   /* func frontCardViewFrame() -> CGRect {
        horizontalPadding := 20.0;
        topPadding = 60.0;
        bottomPadding = 200.0;
        return CGRectMake(horizontalPadding,
            topPadding,
            CGRectGetWidth(self.view.frame) - (horizontalPadding * 2),
            CGRectGetHeight(self.view.frame) - bottomPadding);
    }
    
    - (CGRect)backCardViewFrame {
    CGRect frontFrame = [self frontCardViewFrame];
    return CGRectMake(frontFrame.origin.x,
    frontFrame.origin.y + 10.f,
    CGRectGetWidth(frontFrame),
    CGRectGetHeight(frontFrame));
    }*/

}
