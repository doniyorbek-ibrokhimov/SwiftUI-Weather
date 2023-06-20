//
//  ViewModel.swift
//  SwiftUI-Weather
//
//  Created by Doniyorbek Ibrokhimov  on 18/06/23.
//

import Foundation
import CoreLocation

private let weekDays = [
    1 : "Monday",
    2 : "Tuesday",
    3 : "Wednesday",
    4 : "Thursday",
    5 : "Friday",
    6 : "Saturday",
    7 : "Sunday"
]

class ViewModel: ObservableObject {
    
    @Published var weatherDataArray = [WeatherData]()
    
    func getWeatherData(cityName: String) async {
//        https://api.openweathermap.org/data/2.5/forecast?q=Tashkent&appid=4fe76d6d3ca3d145536320183e9e51a0
        
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/forecast") else { fatalError("Wrong url string") }
        
        guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true) else { fatalError("Unable to resolve url components") }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "q", value: cityName),
            URLQueryItem(name: "appid", value: "4fe76d6d3ca3d145536320183e9e51a0")
        ]
        
        guard let endpoint = urlComponents.url else { fatalError("Unable to get final url") }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: endpoint)
            
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else { fatalError("Wrong status code") }
            
            let decoder = JSONDecoder()
            let parsedWeatherData = try decoder.decode(ParsedWeatherData.self, from: data)
            extractWeatherData(from: parsedWeatherData)
            
        }
        catch {
            fatalError("Error: \(error.localizedDescription)")
        }
    }
    
    func extractWeatherData(from parsedWeatherData: ParsedWeatherData) {
        let cityName = parsedWeatherData.city.name
        
        var weatherDataArray = [WeatherData]()
        
        var i = 3
        
        while i < parsedWeatherData.list.count {
        
            let temperature = Int(parsedWeatherData.list[i].main.temp)
            let conditionId = parsedWeatherData.list[i].weather[0].id
            
            let date = parsedWeatherData.list[i].dt_txt
            let weekday = getWeekday(dateString: date)
            
            let weatherData = WeatherData(conditionId: conditionId, cityName: cityName, temperature: temperature, weekday: weekday)
            
            weatherDataArray.append(weatherData)
            
            i += 8
        }
        
        DispatchQueue.main.async {
            self.weatherDataArray = weatherDataArray
        }
        
    }
    
    private func getWeekday(dateString: String) -> String {
        let correctDateString = dateString[0...9]
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        
        let date = formatter.date(from: correctDateString)
        
        guard let date = date else { fatalError("Error converting string to date") }
        
        let weekday = Calendar.current.component(.weekday, from: date)
        
        guard let weekday = weekDays[weekday] else { fatalError("Error getting weekday") }
        
        return weekday
    }

    
}
