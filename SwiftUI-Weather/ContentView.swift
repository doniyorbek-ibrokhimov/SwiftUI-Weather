//
//  ContentView.swift
//  SwiftUI-Weather
//
//  Created by Doniyorbek Ibrokhimov  on 17/06/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ViewModel()
    @StateObject var locationDataManager = LocationDataManager()
    
    var body: some View {
        ZStack {
            BackgroundView()
            
            VStack {
                SearchView()
                
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
                
               await viewModel.getWeeklyWeatherData()
            }
        }
//        .environmentObject(viewModel)
    }
}

struct DaysView: View {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        HStack {
            ForEach(viewModel.weeklyWeatherData, id: \.self) { weatherData in
                
                let day = DayWeather(dayOfWeek: weatherData.weekday,
                                     imageName: weatherData.conditionName,
                                     temperature: weatherData.temperatureInCelcius)
                
                WeatherDayView(day: day)
            }
        }
    }
}

struct SearchView: View {
    @State var cityName = String()
    @State private var isTextFieldEmpty: Bool = true
    @EnvironmentObject var viewModel: ViewModel
    
    var body: some View {
        HStack{
            TextField("City Name", text: $cityName)
                .font(.system(size: 16, weight: .medium))
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(10)
                .padding()
            
            Button {
                isTextFieldEmpty = cityName.count == 0 
                
                if !isTextFieldEmpty {
                    Task {
                        await viewModel.fetchWeatherData(with: cityName)
                    }
                } else {
                    print("Please enter valid city name")
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
    @State private var isShowingSheet = false
    
    var body: some View {
        VStack {
            
            Text(day.dayOfWeek)
                .font(.system(size: 16, weight: .medium, design: .default))
                .foregroundStyle(.white)
            
            Button(action: {
                isShowingSheet.toggle()
                
            }, label: {
                Image(systemName: day.imageName)
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 40)
            })
            .sheet(isPresented: $isShowingSheet, content: {
                DetailedWeatherView(weekday: day.dayOfWeek)
                    .presentationDetents([.large])
            })
            
            Text("\(day.temperature)°")
                .font(.system(size: 28, weight: .medium))
                .foregroundStyle(.white)
        }
        
    }
}

struct DetailedWeatherView: View {
    @EnvironmentObject var viewModel: ViewModel
    var weekday: String
    
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible()),
        
    ]
    
    var body: some View {
        LazyVGrid(columns: columns) {
            ForEach(viewModel.dailyWeatherData, id: \.self) { weatherData in
               
                let day = DayWeather(dayOfWeek: weatherData.weekday,
                                     imageName: weatherData.conditionName,
                                     temperature: weatherData.temperatureInCelcius)
                
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
        .onAppear() {
            viewModel.getDailyWeatherData(weekday: weekday)
        }
    }
}

struct BackgroundView: View {
    var body: some View {
        LinearGradient(gradient: Gradient(colors: [.blue, .white]),
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//#Preview {
//    ContentView()
//}
