//
//  Country.swift
//  GlovoApp
//
//  Created by Josue Hernandez Gonzalez on 27/12/2018.
//  Copyright © 2018 Josue Hernandez Gonzalez. All rights reserved.
//

import UIKit

@objc public class Country: NSObject {

    public var code: String?
    public var name: String?
    
    init?(dictionary: NSDictionary?) {
        if (dictionary == nil) {
            return nil
        }

        self.code = dictionary!["code"] as? String
        self.name = dictionary!["name"] as? String
    }
    
}
