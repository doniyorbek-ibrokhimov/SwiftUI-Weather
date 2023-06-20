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
    let date: String
}
