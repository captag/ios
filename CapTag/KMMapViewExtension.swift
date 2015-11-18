//
//  KMMapViewExtension.swift
//  CapTag
//
//  Created by Edgar Kuskov on 18.11.15.
//  Copyright © 2015 Edgar Kuskov. All rights reserved.
//

import Foundation
import MapKit
import Mapbox

extension MGLMapView {
        func zoomToFitAllAnnotationsAnimated(animated:Bool) {
            
            let mapEdgePadding = UIEdgeInsets(top: 40, left: 40, bottom: 40, right: 40)
            let annotations = self.annotations
            
            if annotations!.count > 0 {
                
                let firstCoordinate = self.userLocation!.coordinate
                
                //Find the southwest and northeast point
                var northEastLatitude = firstCoordinate.latitude
                var northEastLongitude = firstCoordinate.longitude
                var southWestLatitude = firstCoordinate.latitude
                var southWestLongitude = firstCoordinate.longitude
                
                for annotation in annotations! {
                    let coordinate = annotation.coordinate
                    
                    northEastLatitude = max(northEastLatitude, coordinate.latitude)
                    northEastLongitude = max(northEastLongitude, coordinate.longitude)
                    southWestLatitude = min(southWestLatitude, coordinate.latitude)
                    southWestLongitude = min(southWestLongitude, coordinate.longitude)
                    
                    
                }
                let verticalMarginInPixels = 80.0
                let horizontalMarginInPixels = 40.0
                
                let verticalMarginPercentage = verticalMarginInPixels/Double(self.bounds.size.height)
                let horizontalMarginPercentage = horizontalMarginInPixels/Double(self.bounds.size.width)
                
                let verticalMargin = (northEastLatitude-southWestLatitude)*verticalMarginPercentage
                let horizontalMargin = (northEastLongitude-southWestLongitude)*horizontalMarginPercentage
                
                southWestLatitude -= verticalMargin
                southWestLongitude -= horizontalMargin
                
                northEastLatitude += verticalMargin
                northEastLongitude += horizontalMargin
                
                if (southWestLatitude < -85.0) {
                    southWestLatitude = -85.0
                }
                if (southWestLongitude < -180.0) {
                    southWestLongitude = -180.0
                }
                if (northEastLatitude > 85) {
                    northEastLatitude = 85.0
                }
                if (northEastLongitude > 180.0) {
                    northEastLongitude = 180.0
                }
                
                let bounds = MGLCoordinateBounds(sw: CLLocationCoordinate2DMake(southWestLatitude, southWestLongitude), ne: CLLocationCoordinate2DMake(northEastLatitude, northEastLongitude))

                self.setVisibleCoordinateBounds(bounds, edgePadding: mapEdgePadding, animated: true)
                
            }
    }
}