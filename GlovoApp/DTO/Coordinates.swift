//
//  Coordinates.swift
//  GlovoApp
//
//  Created by Josue Hernandez Gonzalez on 31/12/2018.
//  Copyright © 2018 Josue Hernandez Gonzalez. All rights reserved.
//

import UIKit
import CoreLocation

@objc public class Coordinates: NSObject {
    
    public var lat: Double = 0
    public var lng: Double = 0
    
    init?(data: CLLocationCoordinate2D) {
        self.lat = data.latitude
        self.lng = data.longitude
    }
}
