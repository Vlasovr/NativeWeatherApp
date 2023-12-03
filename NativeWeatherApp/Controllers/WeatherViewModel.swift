//
//  WeatherViewModel.swift
//  NativeWeatherApp
//
//  Created by Роман Власов on 3.12.23.
//

import Foundation

final class WeatherViewModel {
    var currentWeather = Bindable<WeatherData>(WeatherData(cod: "", list: [], city: nil))
    
    let networkService: NetworkService!
    
    init(networkService: NetworkService) {
        self.networkService = networkService
    }

    func getDataToSetupScreen() {
        loadWeatherData()
    }
    
    func loadWeatherData() {
        networkService.getWeather { [weak self] data in
            if let data {
                self?.currentWeather.value = data
            }
        }
    }
    
    func cityEntered(city: String) {
        searchCityWeather(from: city)
    }
    
    func searchCityWeather(from chosenCity: String) {
        networkService.getWeather(city: chosenCity)  { [weak self] data in
            if let data {
                self?.currentWeather.value = data
            }
        }
    }
    
    func configureWeekday(_ weather: Weather) -> String? {
        let dateString = String(weather.dt_txt.dropLast(Constants.WeatherController.lastCharactersToDrop))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = Constants.WeatherController.dateFormat
        guard let date = dateFormatter.date(from: dateString) else { return nil }
        return getWeekday(for: date)
    }
    
    func getWeekday(for date: Date) -> String {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date)
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: Constants.WeatherController.dateFormatterLocale)
        return dateFormatter.shortWeekdaySymbols[weekday - 1].localized
    }
}
