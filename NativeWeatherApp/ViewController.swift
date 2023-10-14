import UIKit
import SnapKit

class ViewController: UIViewController {
    
    private lazy var weatherDescriptionLabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    let networkService = NetworkService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(weatherDescriptionLabel)
        
        weatherDescriptionLabel.snp.makeConstraints { make in
            make.height.equalToSuperview()
            make.width.equalToSuperview()
        }
        networkService.getWeather { [weak self] data in
            if let data {
                DispatchQueue.main.async {
                    self?.setupUI(with: data)
                }

            }
        }
        
    }
    
    private func setupUI(with data: WeatherData) {
        if let country =  data.city?.country,
           let cityName = data.city?.name,
           let latitude = data.city?.coord?.lat,
           let longtitude = data.city?.coord?.lon
        {
            let coordinates = String(latitude) + String(longtitude)
            
            let locationString = country + cityName + coordinates
            
            let weatherDataList = data.list
            
            var labelText = ""
            weatherDataList.forEach { weatherData in
                if let weatherData {
                    labelText += " \(weatherData.main.temp) "
                    labelText += " \(weatherData.main.feels_like) "
                    labelText += " \(weatherData.main.humidity) "
                    labelText += " \(weatherData.main.pressure) "
                    
                    if let description = weatherData.weather.first?.description {
                        labelText += description + " "
                    }
                    
                    labelText += " \(weatherData.wind.speed) "
                    labelText += weatherData.dt_txt + " "
                    labelText += "\n"
                }
                
            }
            
            weatherDescriptionLabel.text = locationString + labelText
        }
    }


}

