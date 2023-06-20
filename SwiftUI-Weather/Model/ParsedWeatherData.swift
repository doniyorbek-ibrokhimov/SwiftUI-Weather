//
//  ParsedWeatherData.swift
//  SwiftUI-Weather
//
//  Created by Doniyorbek Ibrokhimov  on 18/06/23.
//

import Foundation

// list[0].main.temp
// list[0].weather[0].id
// list[0].dt_txt
struct ParsedWeatherData: Codable {
    let list: [List]
    
}

struct List: Codable {
    let main: Main
    let weather: [Weather]
    let dt_txt: String

}

struct Weather: Codable {
    let id: Int

}

struct Main: Codable {
    let temp: Double
}
