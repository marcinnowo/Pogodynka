//
//  ViewController.swift
//  pogodynka
//
//  Created by Marcin on 28/01/2017.
//  Copyright © 2017 mercol. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
       
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var descLabel: UILabel!
   
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var navBar: UINavigationBar!
    
    
    var apiID:String = "cb92e4d38b99f0b8bdaa14bcb8840ae9"
    var localIdentifier:String?
    
    @IBAction func openDialog(_ sender: UIBarButtonItem) {
        alertDialog()
    }
    
    
    func alertDialog() {
        
        let alert = UIAlertController(title: "Select City", message: "", preferredStyle: .alert)
        
        var cityField:UITextField?
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
            
            cityField = alert.textFields?[0]
            self.changeCity(city: cityField!.text!)
        }
        
        let cancelAction = UIAlertAction(title: "cancel", style: .default) { (action) in
            
        }
        
        alert.addTextField { (cityField) in
            cityField.placeholder = "city..."
        }
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func changeCity(city:String) {
        
        print("changing city : \(city)")
        
        getCityWeatherData(city) { (temp, desc, icon, lat, lng) in
            
            self.descLabel.text = desc
            self.tempLabel.text = "\(Int(temp))°"
            self.cityLabel.text = city.capitalized
            
            
            self.downloadWeatherIcon(iconID: icon, completion: { (data) in
                self.iconImageView.image = UIImage(data: data)
                
            })
            
            self.getTimeZoneId(lat: lat, lng: lng, completion: { (timeZoneId) in
                
                print("timeZone for \(city) : \(timeZoneId)")
                self.localIdentifier = timeZoneId
                self.dateLabel.text = self.dateFromLocation(identifier: timeZoneId)
                self.timeLabel.text = self.timeFromLocation(identifier: timeZoneId)
            })
        }
    }
    
    func dateFromLocation(identifier: String) -> String {
        
        var dateStr:String?
        
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM dd"
        dateFormatter.timeZone = TimeZone(identifier:identifier)
        
        dateStr = dateFormatter.string(from: currentDate)
        
        return dateStr!
        
    }
    
    func timeFromLocation(identifier: String) -> String  {
        
        var timeStr:String?
        
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.timeZone = TimeZone(identifier:identifier)
        
        timeStr = dateFormatter.string(from: currentDate)
        
        return timeStr!
    }
    
    
    func updateTime() {
        
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm a"
        dateFormatter.timeZone = TimeZone(identifier: self.localIdentifier!)
        
        timeLabel.text = dateFormatter.string(from: currentDate)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let localId = "Europe/London"
        
       
        //set up date & time
        self.dateLabel.text = self.dateFromLocation(identifier: localId)
        self.timeLabel.text = self.timeFromLocation(identifier: localId)
        
        //update Time
        self.localIdentifier = localId
        _ = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.updateTime), userInfo: nil, repeats: true)
        
        //download Data
        getCityWeatherData("London") { (temp, desc, icon, lat, lng) in
            
           // print("the temp is \(temp) : \(desc)")
            //print("lat: \(lat), long: \(lng)")
            
            self.descLabel.text = desc
            self.tempLabel.text = "\(Int(temp))°"
            
            self.downloadWeatherIcon(iconID: icon, completion: { (data) in
                self.iconImageView.image = UIImage(data: data)
                
            })
        }
        
      
    }
    
 
}






