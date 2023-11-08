import UIKit

private extension String {
    static let baseHourlyURL = "https://api.openweathermap.org/data/2.5/forecast?"
}

private enum Components: String {
    case apiKey = "appid=023a64eb49ca8b57ac5f5cfe0452fd7f"
    case units = "units=metric"
    case language = "lang=en"
}

private enum PostTypes: String {
    case GET
    case POST
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
    
    private func sendRequest(
        apiKey: Components,
        units: Components,
        language: Components,
        requestType: PostTypes,
        requestBody: Data? = nil,
        completion: @escaping(Data?) -> Void
    ) {
        guard let locationData = locationManager.getLocation() else { return }
        let baseUrlString = .baseHourlyURL + locationData + "&" + apiKey.rawValue
        let featuresUrl = baseUrlString + "&" + units.rawValue + "&" + language.rawValue
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




