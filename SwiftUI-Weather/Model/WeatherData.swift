//
//  WeatherData.swift
//  SwiftUI-Weather
//
//  Created by Doniyorbek Ibrokhimov  on 18/06/23.
//

import Foundation

struct WeatherData: Hashable {
    let conditionId: Int
    let cityName: String
    let temperature: Int
    
    var temperatureInCelcius: Int {
        return self.temperature - 273
    }
    let weekday: String
    
    var conditionName: String {
        var condition:String
        
        switch conditionId {
        case 200...232:
            condition = "cloud.bolt.fill"
        case 300...321:
            condition = "cloud.drizzle.fill"
        case 500...531:
            condition = "cloud.rain.fill"
        case 600...622:
            condition = "cloud.snow.fill"
        case 701...781:
            condition = "cloud.fog.fill"
        case 800:
            condition = "sun.max.fill"
        case 801...804:
            condition = "cloud.fill"
        default:
            condition = "Error input"
        }
        
        return condition
    }
}
