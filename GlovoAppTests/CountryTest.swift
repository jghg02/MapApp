//
//  CountryTest.swift
//  GlovoAppTests
//
//  Created by Josue Hernandez Gonzalez on 31/12/2018.
//  Copyright © 2018 Josue Hernandez Gonzalez. All rights reserved.
//

import XCTest

@testable import GlovoApp

class CountryTest: XCTestCase {

    func test_initWithDictionaryIsNil() {
        let country = Country(dictionary: nil)
        XCTAssertNil(country)
    }
    
    
    func test_initWithDictionary_CorrecTypes() {
        let dictionary: NSDictionary = ["code": "VE", "name": "Venezuela"]
        let country = Country(dictionary: dictionary)
        
        XCTAssertEqual(country?.code, "VE")
        XCTAssertEqual(country?.name, "Venezuela")
    }
    

}
