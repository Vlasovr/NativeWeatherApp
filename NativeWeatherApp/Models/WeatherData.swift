import Foundation

final class WeatherData: Codable {
    let cod: String
    let list: [Weather?]
    let city: City?
}
