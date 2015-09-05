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
    var image : UIImage!;
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.imageView.image = self.image;
        println(image.size);
        drawCustomImage(CGPointMake(0,0), bottomRight: CGPointMake(100,100))
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

}
