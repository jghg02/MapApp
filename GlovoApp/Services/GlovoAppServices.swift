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
        
        Alamofire.request("https://3f696c32.ngrok.io/api/countries/", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            
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
        
        Alamofire.request("https://3f696c32.ngrok.io/api/cities/", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            
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

        Alamofire.request("https://3f696c32.ngrok.io/api/cities/\(city_code!)", method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            
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
    
    @objc public class func googleMapsAPI(cityName: String?, countryName: String? ,completion: @escaping (GooglePlace?) -> Void) {
        
        let dato = "\(cityName!), \(countryName!)"
        let url: String = "https://maps.googleapis.com/maps/api/geocode/json?address=\(dato)&key=AIzaSyA-IQAMGWSn2XgZs-fbHv46xFX0j1EBEN0".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
            
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
                
                //Return
                completion(GooglePlace(dictionary: json.dictionaryObject! as NSDictionary))
            }
        }
    }
    

}
