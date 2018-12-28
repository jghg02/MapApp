//
//  City.swift
//  GlovoApp
//
//  Created by Josue Hernandez Gonzalez on 27/12/2018.
//  Copyright © 2018 Josue Hernandez Gonzalez. All rights reserved.
//

import UIKit

@objc public class City: NSObject {
    
    public var working_area: [String] = []
    public var code: String?
    public var name: String?
    public var country_code: String?
    
    init?(dictionary: NSDictionary?) {
        if (dictionary == nil) {
            return nil
        }
        
        for current in dictionary!["working_area"] as! [String] {
            self.working_area.append(current)
        }
        
        self.code = dictionary!["code"] as? String
        self.name = dictionary!["name"] as? String
        self.country_code = dictionary!["country_code"] as? String
    }

}
