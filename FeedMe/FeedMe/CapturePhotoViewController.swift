//
//  CapturePhotoViewController.swift
//  FeedMe
//
//  Created by Jordan Brown on 9/5/15.
//  Copyright (c) 2015 woosufjordaline. All rights reserved.
//

import UIKit
import AVFoundation

class CapturePhotoViewController: UIViewController {
    let captureSession = AVCaptureSession()
    var previewLayer : AVCaptureVideoPreviewLayer?
    // If we find a device we'll store it here for later use
    var captureDevice : AVCaptureDevice?
    var stillImageOutput: AVCaptureStillImageOutput!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        captureSession.sessionPreset = AVCaptureSessionPresetHigh
        
        let devices = AVCaptureDevice.devices()

        self.stillImageOutput = AVCaptureStillImageOutput()
        // Loop through all the capture devices on this phone
        for device in devices {
            // Make sure this particular device supports video
            if (device.hasMediaType(AVMediaTypeVideo)) {
                // Finally check the position and confirm we've got the back camera
                if(device.position == AVCaptureDevicePosition.Back) {
                    captureDevice = device as? AVCaptureDevice
                    if captureDevice != nil {
                        println("Capture device found")
                        beginSession()
                    }
                }
            }
        }
        
    }
    
    func focusTo(value : Float) {
        if let device = captureDevice {
            if(device.lockForConfiguration(nil)) {
                device.setFocusModeLockedWithLensPosition(value, completionHandler: { (time) -> Void in
                    //
                })
                device.unlockForConfiguration()
            }
        }
    }
    
    let screenWidth = UIScreen.mainScreen().bounds.size.width
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        var anyTouch = touches.first as! UITouch
        var touchPercent = anyTouch.locationInView(self.view).x / screenWidth
        focusTo(Float(touchPercent))
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        var anyTouch = touches.first! as! UITouch
      
        var touchPercent = anyTouch.locationInView(self.view).x / screenWidth
        focusTo(Float(touchPercent))
    }
    
    func configureDevice() {
        if let device = captureDevice {
            device.lockForConfiguration(nil)
            device.focusMode = .Locked
            device.unlockForConfiguration()
        }
        
    }
    func capturePicture(){
        
        if let videoConnection = stillImageOutput.connectionWithMediaType(AVMediaTypeVideo){
            stillImageOutput.captureStillImageAsynchronouslyFromConnection(videoConnection, completionHandler: {
                (sampleBuffer, error) in
                var imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                var dataProvider = CGDataProviderCreateWithCFData(imageData)
                var cgImageRef = CGImageCreateWithJPEGDataProvider(dataProvider, nil, true, kCGRenderingIntentDefault)
                var image = UIImage(CGImage: cgImageRef, scale: 1.0, orientation: UIImageOrientation.Right)
               
                
                
                var newSize:CGSize = CGSize(width: image!.size.width/10, height: image!.size.height/10)
                let rect = CGRectMake(0,0, newSize.width, newSize.height)
                UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
                
                // image is a variable of type UIImage
                image?.drawInRect(rect)
                
                let newImage = UIGraphicsGetImageFromCurrentImageContext()
                UIGraphicsEndImageContext()
                UIImageWriteToSavedPhotosAlbum(newImage, nil, nil, nil)
                var vc = self.presentingViewController?.storyboard!.instantiateViewControllerWithIdentifier("ImageProcessingViewController") as! ImageProcessingViewController
                vc.image = newImage
                var parent = self.presentingViewController!
                var server = Server()
                server.uploadImage(newImage!)
                self.dismissViewControllerAnimated(true, completion: {
                    parent.presentViewController(vc, animated: true, completion: nil)
                })
                
            })
        }
    }
    
    func screenShot() {
        UIGraphicsBeginImageContext(previewLayer!.bounds.size);
        self.view.layer.renderInContext(UIGraphicsGetCurrentContext())
        var screenShot = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        var vc = self.presentingViewController?.storyboard!.instantiateViewControllerWithIdentifier("ImageProcessingViewController") as! ImageProcessingViewController
        vc.image = screenShot
        var parent = self.presentingViewController!
        self.dismissViewControllerAnimated(true, completion: {
            parent.presentViewController(vc, animated: true, completion: nil)
        })
    }
    
    func beginSession() {
        
        configureDevice()
        
        var err : NSError? = nil
        captureSession.addInput(AVCaptureDeviceInput(device: captureDevice, error: &err))
        
        if err != nil {
            println("error: \(err?.localizedDescription)")
        }
        
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        captureSession.sessionPreset = AVCaptureSessionPresetPhoto
        self.view.layer.addSublayer(previewLayer)
        previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill;
        previewLayer?.frame = CGRectMake(0, self.view.frame.height/4, self.view.frame.width, self.view.frame.width);
        let screenshotButton = UIButton()
        screenshotButton.setImage(UIImage(named: "camicon.png"), forState: UIControlState.Normal)
        screenshotButton.setTitleColor(UIColor.blackColor(), forState: .Normal)
        screenshotButton.frame = CGRectMake(0, self.view.frame.height/2, 300, 500)
        screenshotButton.addTarget(self, action: "capturePicture", forControlEvents: .TouchUpInside)
        self.view.addSubview(screenshotButton)
        screenshotButton.center = CGPointMake(self.view.frame.width/2, screenshotButton.center.y)
        stillImageOutput.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
        
        if captureSession.canAddOutput(stillImageOutput) {
            captureSession.addOutput(stillImageOutput)
        }
        captureSession.startRunning()
    }
}
