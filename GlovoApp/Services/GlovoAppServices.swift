//
//  GlovoAppServices.swift
//  GlovoApp
//
//  Created by Josue Hernandez Gonzalez on 27/12/2018.
//  Copyright © 2018 Josue Hernandez Gonzalez. All rights reserved.
//

import UIKit

import Alamofire
import SwiftyJSON

@objc class GlovoAppServices: NSObject {
    
    let WEB_SERVER_URL = "https://040cc916.ngrok.io"
    
    @objc public class func fetchCountries(completion: @escaping ([Country]?) -> Void) {
        
        Alamofire.request("https://040cc916.ngrok.io/api/countries/", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            
            let tmp : NSMutableArray = []
            
            switch response.result {
            case .failure( _):
                if let data = response.data {
                    print("Print Server Error: " + String(data: data, encoding: String.Encoding.utf8)!)
                }
                //When I get any error return nil
                completion(nil)
                
            case .success(let value):
                let json = JSON(value)
                //print(json)
                for current in json.arrayValue {
                    tmp.add(Country(dictionary: current.dictionaryObject! as NSDictionary)!)
                }
                
                //Return
                completion(tmp as NSArray as? [Country])
                
            }
            
        }
        
    }
    
    @objc public class func fetchCities(completion: @escaping ([City]?) -> Void) {
        
        Alamofire.request("https://040cc916.ngrok.io/api/cities/", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            
            let tmp : NSMutableArray = []
            
            switch response.result {
            case .failure( _):
                if let data = response.data {
                    print("Print Server Error: " + String(data: data, encoding: String.Encoding.utf8)!)
                }
                //When I get any error return nil
                completion(nil)
                
            case .success(let value):
                let json = JSON(value)
                //print(json)
                for current in json.arrayValue {
                    tmp.add(City(dictionary: current.dictionaryObject! as NSDictionary)!)
                }
                //Return
                completion(tmp as NSArray as? [City])
            }
        }
    }
    
    
    @objc public class func fetchCityDetails(city_code: String? ,completion: @escaping (City?) -> Void) {
        
        let params: [String:String] = ["city_code":city_code!]
        
        Alamofire.request("https://040cc916.ngrok.io/api/cities/\(city_code!)", method: .get, parameters: params, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            
            switch response.result {
            case .failure( _):
                if let data = response.data {
                    print("Print Server Error: " + String(data: data, encoding: String.Encoding.utf8)!)
                }
                //When I get any error return nil
                completion(nil)
                
            case .success(let value):
                let json = JSON(value)
                
                //Return
                completion(City(dictionary: json.dictionaryObject! as NSDictionary))
            }
        }
    }
    

}
