//
//  WeatherModel.swift
//  Clima
//
//  Created by Narayan Sajeev on 4/1/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

// NOT TO BE CONFUSED WITH WEATHERDATA, WHICH IS FOR PARSING

// this is used after the parsing is done to represent the details of the current weather, after they are retrieved

// the JSON data is represented by the WeatherData class and when the properties of that object is retrieved, we use this class to represent the final data


// creates a model for the weather data AFTER the parsing is done, and for the app to use when it is displaying info
struct WeatherModel {

//    declare the properties of the weather
    let conditionId: Int
    let cityName: String
    let temperature: Double
    let description: String
    let temp_min: Double
    let temp_max: Double
    let country: String
    
//    temperatureString is a computed variable
    
//    we are defining it here by calculation
    
//    we use temperatureString for printing it onto the app
    var temperatureString: String {
        return String(format: "%.0f", temperature)
    }
    
    var minString: String {
        return "L: \(String(format: "%.0f", temp_min))"
    }
    
    var maxString: String {
        return "H: \(String(format: "%.0f", temp_max))"
    }
    
//    uses the id of the weather to determine which weather image should be displayed
    var conditionImage: String {
        switch conditionId {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...504:
            return "cloud.rain"
        case 511:
            return "cloud.snow"
        case 520...531:
            return "cloud.drizzle"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801:
            return "cloud.sun"
        case 802:
            return "cloud"
        case 803...804:
            return "smoke"
        default:
            return "cloud"
        }
        
    }
    
}
