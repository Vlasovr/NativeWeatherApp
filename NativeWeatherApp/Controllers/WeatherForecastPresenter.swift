import Foundation

protocol WeatherPresenterDelegate: AnyObject {
    func setupWeatherData(data: WeatherData)
}

final class WeatherForecastPresenter {
    
    let networkService = NetworkService()
    
    weak var delegate: WeatherPresenterDelegate?
    
    func getDataToSetupScreen() {
        loadWeatherData()
    }
    
    func loadWeatherData() {
        networkService.getWeather { [weak self] data in
            if let data {
                self?.delegate?.setupWeatherData(data: data)
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
