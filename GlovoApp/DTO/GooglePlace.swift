//
//  GooglePlace.swift
//  GlovoApp
//
//  Created by Josue Hernandez Gonzalez on 30/12/2018.
//  Copyright © 2018 Josue Hernandez Gonzalez. All rights reserved.
//

import UIKit

class GooglePlace: NSObject {

    public var placeId: String?
    public var longName: String?
    public var shortName: String?
    public var formattedAddress: String?
    public var lat: Double?
    public var lng: Double?
    
    init?(dictionary: NSDictionary?) {
        if (dictionary == nil) {
            return nil
        }
        
        for current in dictionary!["results"] as! [AnyObject] {
            self.placeId = current["place_id"] as? String
            self.formattedAddress = current["formatted_address"] as? String
            
            for address in current["address_components"] as! [AnyObject] {
                self.longName = address["long_name"] as? String
                self.shortName = address["short_name"] as? String
                break
            }
            
            let geometry = current["geometry"] as! NSDictionary
            let location = geometry["location"] as! NSDictionary

            self.lat = location["lat"] as? Double
            self.lng = location["lng"] as? Double
        }
        
    }
    
    
    
    
    
}
