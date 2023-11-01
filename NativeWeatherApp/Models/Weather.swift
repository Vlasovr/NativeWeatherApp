import Foundation

final class Weather: Codable {
    let main: MainWeatherInformation
    let weather: [WeatherDescription]
    let clouds: Clouds
    let wind: Wind
    let dt_txt: String
}
