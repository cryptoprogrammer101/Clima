//
//  WeatherData.swift
//  Clima
//
//  Created by Narayan Sajeev on 3/31/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

// creates a format for the data coming straight out of the JSON
// THIS IS NOT USED AFTER THE PARSING IS COMPLETE
// this is purely for parsing purposes, and then after parsing is done, these structs are no longer needed/used

// the codable struct is a combination of the decodable and encodable protocols

//the decodable protocol allows something to be decoded (e.g via JSON)
struct WeatherData: Codable {
    let name: String
    let main: Main
    let weather: [Weather]
    let sys: Sys
    
    
}

struct Main: Codable {
    let temp: Double
    let temp_min: Double
    let temp_max: Double
}

struct Weather: Codable {
    let id: Int
    let main: String
}

struct Sys: Codable {
    let country: String
}
