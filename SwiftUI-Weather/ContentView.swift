//
//  ContentView.swift
//  SwiftUI-Weather
//
//  Created by Doniyorbek Ibrokhimov  on 17/06/23.
//

import SwiftUI

struct ContentView: View {
    
    @State private var isNight = false
    @State private var cityName = "Tashkent"
    
    @StateObject var viewModel = ViewModel()
    
    var body: some View {
        
        ZStack {
            BackgroundView(isNight: $isNight)
            
            VStack {
                HStack{
                    TextField("City Name", text: $cityName)
                        .font(.system(size: 16, weight: .medium))
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(10)
                        .padding()
                    
                    Button {
                        Task {
                            await viewModel.getWeatherData(cityName: cityName)
                        }
                        
                    } label: {
                        Image(systemName: "magnifyingglass")
                            .renderingMode(.original)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.white)
                            .frame(width: 30, height: 30)
                            .padding()
                    }
                
                }
                
                CityTextView(cityName: "Cupertino, CA")
                
                MainWeatherStatusView(
                    imageName: isNight ? "moon.stars.fill" : "cloud.sun.fill",
                    temperature: 76)
                
                
                HStack(spacing: 20) {
                   
                    
                    
                    
//                    let day1 = DayWeather(dayOfWeek: viewModel.$weatherDataArray[0].date,
//                                          imageName: "cloud.sun.fill",
//                                          temperature: 76)

//                    let day2 = DayWeather(dayOfWeek: "WED",
//                                          imageName: "cloud.sun.fill",
//                                          temperature: 76)
//
//                    let day3 = DayWeather(dayOfWeek: "THU",
//                                            imageName: "cloud.sun.fill",
//                                            temperature: 76)
//
//                    let day4 = DayWeather(dayOfWeek: "FRI",
//                                            imageName: "cloud.sun.fill",
//                                            temperature: 76)
//
//                    let day5 = DayWeather(dayOfWeek: "SAT",
//                                            imageName: "cloud.sun.fill",
//                                            temperature: 76)
//
//                    let days = [day1, day2, day3, day4, day5]
//
//
                    
                    WeatherDayView(weatherDataArray: viewModel.$weatherDataArray)
                    
                    
                }
                Spacer()
                
                Button {
                    isNight.toggle()
                    
                    
                } label: {
                    WeatherButton(title: "Change Day Time", textColor: .blue, backgroundColor: .white)
                }
                Spacer()
            }
            
        }
    }
}


#Preview {
    ContentView()
}

struct DayWeather: Identifiable {
    var id: String { dayOfWeek }
    
    let dayOfWeek: String
    let imageName: String
    let temperature: Int
}


struct WeatherDayView: View {
    
    @Binding var weatherDataArray: [WeatherData]
    
    var body: some View {
        
        ForEach(days) { day in
            VStack {
                Text(day.dayOfWeek)
                    .font(.system(size: 16, weight: .medium, design: .default))
                    .foregroundStyle(.white)
                
                Image(systemName: day.imageName)
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
                
                Text("\(day.temperature)°")
                    .font(.system(size: 28, weight: .medium))
                    .foregroundStyle(.white)
            }
        }
    }
}

struct BackgroundView: View {
    @Binding var isNight: Bool
    
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [isNight ? .black : .blue,
                                                   isNight ? .gray : .lightBlue]),
                       startPoint: .topLeading,
                       endPoint: .bottomTrailing)
        .edgesIgnoringSafeArea(.all)
    }
}

struct CityTextView: View {
    var cityName: String
    
    var body: some View {
        Text(cityName)
            .font(.system(size: 32, weight: .medium, design: .default))
            .foregroundStyle(.white)
            .padding()
    }
}

struct MainWeatherStatusView: View {
    
    var imageName: String
    var temperature: Int
    
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: imageName)
                .renderingMode(.original)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 180, height: 180)
            
            Text("\(temperature)°")
                .font(.system(size: 70, weight: .medium))
                .foregroundColor(.white)
        }
        .padding()
    }
}

