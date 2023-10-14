import Foundation

final class MainWeatherInformation: Codable {
    let temp: Double
    let feels_like: Double
    let pressure: Int
    let humidity: Int
}


final class WeatherDescription: Codable {
    let description: String
}

final class Clouds: Codable {
    let all: Int
}

final class Wind: Codable {
    let speed: Double
}
