import Foundation

final class WeatherData: Codable {
    let cod: String
    let list: [Weather?]
    let city: City?
    
    init(cod: String, list: [Weather?], city: City?) {
        self.cod = cod
        self.list = list
        self.city = city
    }
}
