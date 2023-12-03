import Foundation

final class MainWeatherInformation: Codable {
    let temp: Double
    let feels_like: Double
    let pressure: Int
    let humidity: Int
}
