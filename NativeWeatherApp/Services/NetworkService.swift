import UIKit

private extension String {
    static let baseHourlyURL = "https://api.openweathermap.org/data/2.5/forecast?"
}

private enum Components: String {
    case apiKey = "appid=46ef8121e3dd01bf8281202be0002917"
    case units = "units=metric"
    case language = "lang=en"
}

private enum PostTypes: String {
    case GET
}

protocol INetworkService {
    func getWeather(completion: @escaping((WeatherData?) -> Void))
}

final class NetworkService: INetworkService {
    
    let locationManager = LocationManager()
    
    func getWeather(completion: @escaping((WeatherData?) -> Void)) {
        sendRequest(apiKey: .apiKey,
                    units: .units,
                    language: .language,
                    requestType: .GET
        ) { data in
            guard let data else {
                completion(nil)
                return
            }
            
            let array = try? JSONDecoder().decode(WeatherData.self, from: data)
            completion(array)
        }
    }
    
    func getWeather(city: String, completion: @escaping((WeatherData?) -> Void)) {
        sendRequest(city: city,
                    apiKey: .apiKey,
                    units: .units,
                    language: .language,
                    requestType: .GET
        ) { data in
            guard let data else {
                completion(nil)
                return
            }
            
            let array = try? JSONDecoder().decode(WeatherData.self, from: data)
            completion(array)
        }
    }
    
    private func sendRequest(
        city: String? = nil,
        apiKey: Components,
        units: Components,
        language: Components,
        requestType: PostTypes,
        requestBody: Data? = nil,
        completion: @escaping(Data?) -> Void
    ) {
        var baseUrlString = ""
        if let city {
            baseUrlString = .baseHourlyURL + Constants.ApiSettingsOperator.citySetting + city + Constants.ApiSettingsOperator.and + apiKey.rawValue
        } else {
            if let locationData = locationManager.getLocation() {
                baseUrlString = .baseHourlyURL + locationData + Constants.ApiSettingsOperator.and + apiKey.rawValue
            }
        }
        
        let featuresUrl = baseUrlString + Constants.ApiSettingsOperator.and + units.rawValue + Constants.ApiSettingsOperator.and + language.rawValue
        guard let url = URL(string: featuresUrl) else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = requestType.rawValue
        request.httpBody = requestBody
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil,
                  let data else {
                completion(nil)
                return
            }
            completion(data)
        }
        task.resume()
    }
}




