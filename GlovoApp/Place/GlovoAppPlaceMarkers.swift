//
//  GlovoAppPlaceMarkers.swift
//  GlovoApp
//
//  Created by Josue Hernandez Gonzalez on 26/12/2018.
//  Copyright © 2018 Josue Hernandez Gonzalez. All rights reserved.
//

import UIKit

import GoogleMaps
import GooglePlaces

@objc class GlovoAppPlaceMarkers: GMSMarker {
    
    let place: GMSPlace

    init(place: GMSPlace) {
        self.place = place
        super.init()
        
        position = place.coordinate
        groundAnchor = CGPoint(x: 0.5, y: 1)
        appearAnimation = .pop
    }

}
