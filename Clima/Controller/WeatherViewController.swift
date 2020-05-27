//
//  ViewController.swift
//  Clima
//
//  Created by Angela Yu on 01/09/2019.
//  Copyright © 2019 App Brewery. All rights reserved.
//

import UIKit
import CoreLocation


//MARK: - UITextField, UITextFieldDelegate & Protocols Information

// UITextFieldDelegate is a protocol that has some requirements

// if the protocol is inserted after the superclass
// and
// the class meets all the requirements of the protocol
// the delegate of the UITextField can call functions in the class

// the delegate knows the necessary functions are in the class because the delegate knows that the class complies with the protocol
// (otherwise there would be an error saying that the class does not comply with the requirements for the protocol)

// in order to be the delegate of the text field, you must comply to the protocol
// if you follow the protocol, then you can be notified (i.e functions can be run in this class) when events happen

// the textFieldShouldReturn, textFieldShouldEndEditing, and textFieldDidEndEditing functions are in the UITextField class and they are called by the delegate property
// again, it can safely do so because the class follows the protocol, which has a requirement of those functions


// the text fields in the storyboard are instances of the UITextField class, and their actions can be sent to this class through delegates, which are included in the UITextField


//MARK: - WeatherViewController


class WeatherViewController: UIViewController /* superclass */ {

    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var unitsControl: UISegmentedControl!
    @IBOutlet weak var highLabel: UILabel!
    @IBOutlet weak var lowLabel: UILabel!
    @IBOutlet weak var unitsLabel: UILabel!
    
    let units = ["imperial", "metric"]
    
//    creates an instance of the WeatherManager class, which can then do all the functions with retrieving the weather
    var weatherManager = WeatherManager()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

//        set the state of the units
        unitsControl.selectedSegmentIndex = 0
        
        locationManager.delegate = self
        
//        request to have the user's location
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
//        set up the text field to call functions in this class
//        each UITextField has a delegate property
//        set the delegate PROPERTY of the searchTextField to this class, allowing it to be able to call functions in this class
        
//        the property = this class because this class follows UITextFieldDelegate and so does the delegate
        searchTextField.delegate = self
        
//        sets the delegate of the weatherManager to this class so the delegate can run the didFailWithError function in this class
        weatherManager.delegate = self
        
    }
    
    //    if the location button is pressed
    @IBAction func locationPressed(_ sender: UIButton) {
//        request for the location
        locationManager.requestLocation()
                
    }
    
    
//    if someone pressed the units changer
    @IBAction func unitsChanged(_ sender: UISegmentedControl) {
        
        if let cityName = cityLabel.text {
            
//            find the selected unit
            let selectedUnit = unitsControl.selectedSegmentIndex
            
//            find what unit that is
            let unit = units[selectedUnit]
            
//            turn words into a single word separated by + signs
            let splitCity = cityName.split(separator: " ")
            let updatedCity = splitCity.joined(separator: "+")
            
            weatherManager.fetchWeather(cityName: updatedCity, unit)
                    
//        check what they pressed and change the units
            if unitsControl.selectedSegmentIndex == 0 {
                        
                unitsLabel.text = "F"
                        
            } else {
                        
                unitsLabel.text = "C"
                        
            }
                    
        }
            
    }
    
}

//MARK: - UITextFieldDelegate

// the "MARK" creates a line/section in the code named "string", separates different blocks of code from each other

// extends the functionality of the view controller to deal with textfields and typing events
extension WeatherViewController: UITextFieldDelegate /* protocol for the textfield (tells when events happen) */ {

        @IBAction func searchPressed(_ sender: UIButton) {
            
    //        close the keyboard
            searchTextField.endEditing(true)
            
        }
    
//        asks the delegate if the textfield should return
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            searchTextField.endEditing(true)
            return true
        }
        
//        asks delegate if textfield should end editing
        func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
//            make sure the user entered something
            if textField.text != "" {
                return true
            } else {

                textField.placeholder = "Type something"
                return false
            }
        }

//        asks if textfield if it did end editing
        func textFieldDidEndEditing(_ textField: UITextField) {
//            use searchtextfield.text to get weather for city

            searchTextField.placeholder = "Search"
            
//            find the selected unit
            let selectedUnit = unitsControl.selectedSegmentIndex
            
//            find what unit it is
            let unit = units[selectedUnit]
            
            if let city = searchTextField.text {
                
//                turn words into a single word separated by + signs
                let splitCity = city.split(separator: " ")
                let updatedCity = splitCity.joined(separator: "+")
                
                weatherManager.fetchWeather(cityName: updatedCity, unit)
            }

            searchTextField.text = ""
        }
    
}


//MARK: - WeatherManagerDelegate


// adds functionality for events that can be triggered by the weatherManager
extension WeatherViewController: WeatherManagerDelegate /* protocol for weather (used for dealing with errors) */ {
    
    //    updates the weather info
        func didUpdateWeather(_ weatherManager: WeatherManager, _ weather: WeatherModel) {
            
    //        updates the UI while the parsing is running in the background
            DispatchQueue.main.async {
                
    //            update the UI
                self.temperatureLabel.text = weather.temperatureString
                self.conditionImageView.image = UIImage(systemName: weather.conditionName)
                self.cityLabel.text = weather.cityName
                self.highLabel.text = weather.maxString
                self.lowLabel.text = weather.minString
                
            }
        
        }

    //    runs this function when there is an error with the parsing
        func didFailWithError(_ error: Error) {
            DispatchQueue.main.async {
//                self.searchTextField.placeholder = "Error"
            }
        }
    
}


//MARK: - CLLocationManager


extension WeatherViewController:  CLLocationManagerDelegate /* protocol for location services */ {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        retrieved location
        
//        the most recent/accurate location is the last one
        if let location = locations.last {
            
//            as soon as you got the user's location, stop requesting for it
            locationManager.stopUpdatingLocation()
            
            let lat = location.coordinate.latitude
            let lon  = location.coordinate.longitude
         
            let selectedUnit = unitsControl!.selectedSegmentIndex
            
            let unit = units[selectedUnit]
            
            weatherManager.fetchWeather(latitude: lat, longitude: lon, unit)
            
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//        had an error
        DispatchQueue.main.async {
//            self.searchTextField.placeholder = "Error"
        }
        
    }
    
}
