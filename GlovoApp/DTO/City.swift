//
//  City.swift
//  GlovoApp
//
//  Created by Josue Hernandez Gonzalez on 27/12/2018.
//  Copyright © 2018 Josue Hernandez Gonzalez. All rights reserved.
//

import UIKit
import Polyline
import CoreLocation

@objc public class City: NSObject {
    
    public var working_area: [String] = []
    public var code: String?
    public var name: String?
    public var country_code: String?
    public var descriptionCity: String?
    public var currency: String?
    public var time_zone: String?
    public var language_code: String?
    public var polygone_data: [Coordinates]? = []
    
    init?(dictionary: NSDictionary?) {
        super.init()
        if (dictionary == nil) {
            return nil
        }
        
        for current in dictionary!["working_area"] as! [String] {
            self.working_area.append(current)
        }
        
        self.code = dictionary!["code"] as? String
        self.name = dictionary!["name"] as? String
        self.country_code = dictionary!["country_code"] as? String
        
        self.descriptionCity = dictionary!["description"] as? String
        self.currency = dictionary!["currency"] as? String
        self.time_zone = dictionary!["time_zone"] as? String
        self.language_code = dictionary!["language_code"] as? String
        
        self.decodePolygone(area: self.working_area)
    }

    func decodePolygone(area: [String?]) {
        
        for current in area {
            let polyline = Polyline(encodedPolyline: current!)
            let decodedCoordinates: [CLLocationCoordinate2D]? = polyline.coordinates
            self.processCoordinate(data: decodedCoordinates)
        }
    }
    
    func processCoordinate(data: [CLLocationCoordinate2D]?) {
        
        for current in data! {
            self.polygone_data?.append(Coordinates(data: current)!)
        }
        
    }
    
}
