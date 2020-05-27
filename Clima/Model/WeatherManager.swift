//
//  WeatherManager.swift
//  Clima
//
//  Created by Narayan Sajeev on 3/26/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import CoreLocation

// make a protocol for delegates of the weather manager to follow
// if a class follows this protocol, they can be updated on the weather
protocol WeatherManagerDelegate {
    
//    the two functions that are necessary
    func didUpdateWeather(_ weatherManager: WeatherManager, _ weather: WeatherModel)
    func didFailWithError(_ error: Error)
}

// create a struct that can do all the tasks with the weather
// do these tasks simply by calling the functions in this class
struct WeatherManager {
    
//    declare the url
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=f0f7ee41fa26c17841ec6551f4d4c3a7"
    
//    make a delegate so other classes/structs can have the classes' functions called by this delegate when events happen here
    var delegate: WeatherManagerDelegate?
    
//    make a function to fetch the weather
    func fetchWeather(cityName: String, _ units: String) {
        
//        update the url to include the city
        let urlString = "\(weatherURL)&q=\(cityName)&units=\(units)"
        
//        do the request
        performRequest(with: urlString)
        
    }
    
    func fetchWeather(latitude: CLLocationDegrees, longitude: CLLocationDegrees, _ units: String) {
        
//        update the url to include the city
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)&units=\(units)"
                
//        do the request
        performRequest(with: urlString)
        
    }
    
    func performRequest(with urlString: String) {
//        make a url
        if let url = URL(string: urlString) {

//            make a url session
            let session = URLSession(configuration: .default)
            
//            give the session a task
            
//            completion handler (the stuff in the braces aka A CLOSURE) runs a function when the task is trying to retrieve the url
            let task = session.dataTask(with: url) { (data, response, error) in
                        if error != nil {
                            self.delegate?.didFailWithError(error!)
                //            the return by itself ends the execution of the function
                            return
                        }
                        
//                      makes sure we dont have an optional with the data coming out
                        if let safeData = data {
//                            makes sure that the weather is not an optional,
//                            since the function may not be able to retrieve the weather if it cant decode the JSON
                            if let weather = self.parseJSON(safeData) {
                                self.delegate?.didUpdateWeather(self, weather)
                                
                            }
                            
                        }
            }
            
//            start the task
            task.resume()
            
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        
        do {
//            decode the data into a WeatherData class from the weatherData variable
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            
//            retrieve the data by parsing it
            let id = decodedData.weather[0].id
            let name = decodedData.name
            let temp = decodedData.main.temp
            let temp_min = decodedData.main.temp_min
            let temp_max = decodedData.main.temp_max
            let description = decodedData.weather[0].description
            
//            make a weather model that has properties of the weather
//            we can easily pull out details from the weather by retrieving properties from this object
            let weather = WeatherModel(conditionId: id, cityName: name, temperature: temp, description: description, temp_min: temp_min, temp_max: temp_max)
            
//            return the weather object
            return weather
            
//            if theres an error
        } catch {
            
//            make the delegate (if its not nil) deal with the error
            delegate?.didFailWithError(error)
            
//            return nil
            return nil
            
        }
        
    }    
}
