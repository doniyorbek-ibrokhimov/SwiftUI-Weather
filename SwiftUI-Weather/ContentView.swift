//
//  ContentView.swift
//  SwiftUI-Weather
//
//  Created by Doniyorbek Ibrokhimov  on 17/06/23.
//

import SwiftUI


struct ContentView: View {
    
    @State private var isNight = false
    @State private var cityName = String()
    @StateObject private var viewModel = ViewModel()
    @StateObject var locationDataManager = LocationDataManager()
    
    @State var days: [DayWeather] = []
    var body: some View {
    
        ZStack {
            BackgroundView(isNight: $isNight)
            
            VStack {
                
                SearchView(cityName: $cityName, days: $days, viewModel: viewModel)
                
                MainWeatherStatusView(imageName: "cloud.sun.fill", temperature: 25)

               
                DaysView(viewModel: viewModel)
                
       
                Spacer()
                
            }
            
        }
        .onAppear {
            let longtitude  = locationDataManager.longtitude
            let latitude = locationDataManager.latitude
            
            Task {
               await viewModel.fetchWeatherData(longtitude: longtitude, latitude: latitude)
            }
        }
    }
}

struct DaysView: View {

    @StateObject var viewModel: ViewModel
    
    var body: some View {
        HStack {
            ForEach(viewModel.weatherDataArray, id: \.self) { weatherData in
                
                let day = DayWeather(dayOfWeek: weatherData.weekday, imageName: weatherData.conditionName, temperature: weatherData.temperatureInCelcius)
                
                WeatherDayView(day: day)
            }
        }
    }
}

struct SearchView: View {
    @Binding var cityName: String
    @Binding var days: [DayWeather]
    var viewModel: ViewModel
    
    var body: some View {
        HStack{
            TextField("City Name", text: $cityName)
                .font(.system(size: 16, weight: .medium))
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(10)
                .padding()
            
            Button {
                Task {
                    await viewModel.fetchWeatherDate(with: cityName)
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
        
    }
}

struct WeatherDayView: View {
    
    var day: DayWeather
    
    
    var body: some View {
        
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



#Preview {
    ContentView()
}
