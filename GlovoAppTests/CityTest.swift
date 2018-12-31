//
//  CityTest.swift
//  GlovoAppTests
//
//  Created by Josue Hernandez Gonzalez on 31/12/2018.
//  Copyright © 2018 Josue Hernandez Gonzalez. All rights reserved.
//

import XCTest

@testable import GlovoApp

class CityTest: XCTestCase {

    func test_initWithDictionaryIsNil() {
        let city = City(dictionary: nil)
        XCTAssertNil(city)
    }
    
    
    func test_initWithDictionary_CorrecTypes() {
        let dictionary: NSDictionary = ["code": "CCS", "name": "Venezuela", "country_code": "VE", "working_area" : []]
        let city = City(dictionary: dictionary)
        
        XCTAssertEqual(city?.code, "CCS")
        XCTAssertEqual(city?.name, "Venezuela")
        XCTAssertEqual(city?.country_code, "VE")
        XCTAssertNotNil(city?.working_area)
    }
    
    func test_initWithAllInfo()  {
        let dictionary: NSDictionary = ["code": "CCS", "name": "Venezuela", "country_code": "VE", "working_area" : [], "currency":"Bs","time_zone":"Caracas-GTM-3","language_code":"ES"]
        let city = City(dictionary: dictionary)
        
        XCTAssertEqual(city?.code, "CCS")
        XCTAssertEqual(city?.name, "Venezuela")
        XCTAssertEqual(city?.country_code, "VE")
        XCTAssertNotNil(city?.working_area)
        XCTAssertEqual(city?.currency, "Bs")
        XCTAssertEqual(city?.time_zone, "Caracas-GTM-3")
        XCTAssertEqual(city?.language_code, "ES")
    }
    

}
