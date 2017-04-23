//
//  ViewControllerExct.swift
//  pogodynka
//
//  Created by Marcin on 31/01/2017.
//  Copyright © 2017 mercol. All rights reserved.
//
import UIKit
extension ViewController {
  
 
    func getCityWeatherData(_ stringCity:String, completion:@escaping (_ weather:Double, _ desc:String, _ icon:String, _ lat:Double, _ lng:Double)->()) {
        
        
        let cityFiltered:String = stringCity.replacingOccurrences(of: " ", with: "+")
        
        let url:URL = URL(string: "http://api.openweathermap.org/data/2.5/weather?q=\(cityFiltered)&appid=\(apiID)")!
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            
            if error == nil {
                
                if let dataValid = data {
                    
                    do {
                        let jsonDict = try JSONSerialization.jsonObject(with: dataValid, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                        
                        print(jsonDict)
                        
                        let coord = jsonDict["coord"] as! NSDictionary
                        let latCoord = coord["lat"] as! Double
                        let lngCoord = coord["lon"] as! Double
                        
                        let weather = jsonDict["weather"] as! NSArray
                        let weather0 = weather[0] as! NSDictionary
                        let desc = weather0["description"] as! String
                        let icon = weather0["icon"] as! String
                        
                        let main = jsonDict["main"] as! NSDictionary
                        let temp = main["temp"] as! Double
                        let tempCelsius = temp - 273.15
                        
                        DispatchQueue.main.async(execute: {
                            completion(tempCelsius, desc, icon, latCoord, lngCoord)
                        })
                    } catch {
                        print(error.localizedDescription)
                    } // do
                }// if
            } //if
            
        } // task
        
        task.resume()
    }
    
    
    func downloadWeatherIcon(iconID:String, completion:@escaping (_ imgData:Data)->()) {
        
        
        let url:URL = URL(string: "http://openweathermap.org/img/w/\(iconID).png")!
        
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            if error == nil {
                
                if let dataOk = data {
                    
                    do {
                        
                        DispatchQueue.main.async(execute: {
                            completion(dataOk)
                        })
                        
                    } catch {
                        print(error.localizedDescription)
                    } // do
                } // if
            } // if
        } //task
        
        task.resume()
        
    }
    func getTimeZoneId(lat:Double, lng:Double, completion: @escaping (_ identifier:String) ->())
    {
        let key = "AIzaSyBb8hFbjXdzo5SOjqbswzRTjkIxX_HCbFU"
        let url = URL(string: "https://maps.googleapis.com/maps/api/timezone/json?location=\(lat),\(lng)&timestamp=1331161200&key=\(key)")
        var identifier:String?
        
        let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
            
            if error == nil {
                
                if let dataValid = data {
                    
                    do {
                        let jsonDict = try JSONSerialization.jsonObject(with: dataValid, options: JSONSerialization.ReadingOptions.mutableContainers) as! NSDictionary
                        
                        
                        identifier = jsonDict["timeZoneId"] as! String
                        
                        
                        DispatchQueue.main.async(execute: {
                            completion(identifier!)
                        })
                    } catch {
                        print(error.localizedDescription)
                    } // do
                }// if
            } //if
            
        } // task
        
        task.resume()
        
        
        
    }

    
    }
