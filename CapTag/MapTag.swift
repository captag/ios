//
//  MapTag.swift
//  CapTag
//
//  Created by Edgar Kuskov on 18.11.15.
//  Copyright © 2015 Edgar Kuskov. All rights reserved.
//

import Foundation
import MapKit
import UIKit
import Mapbox

class MapTag: NSObject, MGLAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String
    
    init(title: String, coordinate: CLLocationCoordinate2D, info: String) {
        self.title = title
        self.coordinate = coordinate
        self.info = info
    }
}