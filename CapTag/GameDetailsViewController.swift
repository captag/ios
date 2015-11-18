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

class GameDetailsViewController: UIViewController, MGLMapViewDelegate {
    
    var mapView: MGLMapView!
    
    var currentGame : Game?
    var tags = [MGLAnnotation]()
    
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

