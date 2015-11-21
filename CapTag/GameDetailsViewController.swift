//
//  RegisterViewController.swift
//  CapTag
//
//  Created by Edgar Kuskov on 12.11.15.
//  Copyright © 2015 Edgar Kuskov. All rights reserved.
//

import UIKit
import MapKit
import Parse
import Mapbox
import CoreLocation
import AVFoundation

class GameDetailsViewController: UIViewController, MGLMapViewDelegate, AVCaptureMetadataOutputObjectsDelegate {
    
    var mapView: MGLMapView!
    
    var captureSession:AVCaptureSession?
    var videoPreviewLayer:AVCaptureVideoPreviewLayer?
    var qrCodeFrameView = UIView()
    var scannerView = UIView()
    
    var currentGame : Game?
    var tags = [MGLAnnotation]()
    
    var showScannerView = false
    let scanViewHeight = 300
    var buttonLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        self.title = currentGame!.name
        
        // initialize the map view
        let styleURL = NSURL(string: "asset://styles/dark-v8.json")
        mapView = MGLMapView(frame: view.bounds, styleURL: styleURL)
        mapView.centerCoordinate = CLLocationCoordinate2D(latitude: 47.6765265, longitude: 9.1730298)
        mapView.showsUserLocation = true
        mapView.delegate = self
        mapView.autoresizingMask = view.autoresizingMask
        mapView.userTrackingMode = MGLUserTrackingMode.FollowWithCourse
        view.addSubview(mapView)
        
        // Get an instance of the AVCaptureDeviceInput class using the previous device object.
        let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        do {
            let input: AnyObject! = try AVCaptureDeviceInput.init(device: captureDevice)
            captureSession = AVCaptureSession()
            captureSession?.addInput(input as! AVCaptureInput)
        } catch let error as NSError {
            print("AV Sound Error: \(error.localizedDescription)")
        }
        
        // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
        let captureMetadataOutput = AVCaptureMetadataOutput()
        captureSession?.addOutput(captureMetadataOutput)
        
        
        // Set delegate and use the default dispatch queue to execute the call back
        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
        captureMetadataOutput.metadataObjectTypes = [AVMetadataObjectTypeQRCode]
        
        
        // Create a view for scanning
        scannerView = UIView(frame: CGRect.init(x: 0, y: self.view.frame.height-50, width: self.view.frame.width, height: 400))
        scannerView.backgroundColor = UIColor.redColor()
        scannerView.autoresizingMask = view.autoresizingMask
        view.addSubview(scannerView)
        view.bringSubviewToFront(scannerView)
        
        // Init video view and add it to scanning view
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        scannerView.layer.addSublayer(videoPreviewLayer!)
        
        // Initialize QR Code Frame to highlight the QR code
        qrCodeFrameView.layer.borderColor = UIColor.grayColor().CGColor
        qrCodeFrameView.layer.borderWidth = 2
        scannerView.addSubview(qrCodeFrameView)
        scannerView.bringSubviewToFront(qrCodeFrameView)
        
        // Add button to show scan view
        let buttonView = UIView(frame: CGRect.init(x: 0, y: 0, width: self.view.frame.width, height: 50))
        buttonView.autoresizingMask = view.autoresizingMask
        buttonView.backgroundColor = UIColor.grayColor()
        scannerView.addSubview(buttonView)
        let gesture = UITapGestureRecognizer(target: self, action: "showScanView:")
        buttonView.addGestureRecognizer(gesture)
        buttonLabel = UILabel(frame: buttonView.frame)
        buttonLabel.textAlignment = NSTextAlignment.Center
        buttonLabel.text = "Scan the QR Code"
        buttonView.addSubview(buttonLabel)
        
        // Swipe to top to show the view
        let upSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        let downSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
        upSwipe.direction = .Up
        downSwipe.direction = .Down
        scannerView.addGestureRecognizer(upSwipe)
        scannerView.addGestureRecognizer(downSwipe)
    }
    
    func handleSwipes(sender:UISwipeGestureRecognizer) {
        if (sender.direction == .Up && !showScannerView) {
            UIView.animateWithDuration(1.2, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: .CurveEaseInOut, animations: {
                self.buttonLabel.textColor = UIColor.grayColor()
                self.buttonLabel.backgroundColor = UIColor.whiteColor()
                self.mapView.frame.origin.y -= 300
                self.scannerView.frame.origin.y -= 300
                self.captureSession?.startRunning()
                }, completion: nil)
            showScannerView = true
        } else if (sender.direction == .Down && showScannerView) {
            UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                self.buttonLabel.textColor = UIColor.whiteColor()
                self.buttonLabel.backgroundColor = UIColor.grayColor()
                self.mapView.frame.origin.y += 300
                self.scannerView.frame.origin.y += 300
                self.captureSession?.stopRunning()
                }, completion: nil)
            showScannerView = false
        }
    }
    
    func showScanView(sender:UITapGestureRecognizer){
        if(!showScannerView) {
            UIView.animateWithDuration(1.2, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, options: .CurveEaseInOut, animations: {
                self.buttonLabel.textColor = UIColor.grayColor()
                self.buttonLabel.backgroundColor = UIColor.whiteColor()
                self.mapView.frame.origin.y -= 300
                self.scannerView.frame.origin.y -= 300
                self.captureSession?.startRunning()
                }, completion: nil)
            showScannerView = true
        } else {
            UIView.animateWithDuration(0.3, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                self.buttonLabel.textColor = UIColor.whiteColor()
                self.buttonLabel.backgroundColor = UIColor.grayColor()
                self.mapView.frame.origin.y += 300
                self.scannerView.frame.origin.y += 300
                self.captureSession?.stopRunning()
                }, completion: nil)
            showScannerView = false
        }
    }

    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects == nil || metadataObjects.count == 0 {
            qrCodeFrameView.frame = CGRectZero
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if metadataObj.type == AVMetadataObjectTypeQRCode {
            // If the found metadata is equal to the QR code metadata then update the status label's text and set the bounds
            let barCodeObject = videoPreviewLayer?.transformedMetadataObjectForMetadataObject(metadataObj as AVMetadataMachineReadableCodeObject) as! AVMetadataMachineReadableCodeObject
            qrCodeFrameView.frame = barCodeObject.bounds;
            
            if metadataObj.stringValue != nil {
                buttonLabel.text = metadataObj.stringValue
                print(metadataObj.stringValue)
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // Show the tags
        let query = GameTag.query()
        query!.whereKey("game", equalTo:self.currentGame!)
        query!.findObjectsInBackgroundWithBlock {
            (objects: [PFObject]?, error: NSError?) -> Void in
            if error == nil {
                for object in objects! {
                    let gameTag = (object as! GameTag)
                    let geoPoint = gameTag.geoPoint
                    let latitude: CLLocationDegrees = geoPoint.latitude
                    let longtitude: CLLocationDegrees = geoPoint.longitude
                    let location: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
                    let mapTag = MapTag(title: gameTag.label!, coordinate: location, info: gameTag.label!)
                    self.tags.append(mapTag)
                }
                self.mapView.addAnnotations(self.tags)
                self.mapView.zoomToFitAllAnnotationsAnimated(true)
            } else {
                print("Error")
            }
        }
    }
    
    func mapView(mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

