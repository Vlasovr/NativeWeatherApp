import UIKit

protocol WeatherImageSetup {
    func setupWeatherImage(with model: ForecastCellModel, weatherImageView: UIImageView)
}

extension WeatherImageSetup {
    func setupWeatherImage(with model: ForecastCellModel, weatherImageView: UIImageView) {
           let description = model.description
           configureWeatherImage(with: description, weatherImageView: weatherImageView)
       }
       
       private func configureWeatherImage(with description: String, weatherImageView: UIImageView) {
           switch description {
               
           case Constants.WeatherType.clearSky:
               weatherImageView.image = UIImage(systemName: Constants.WeatherImages.clearSky)
               
           case Constants.WeatherType.brokenClouds:
               weatherImageView.image = UIImage(systemName: Constants.WeatherImages.brokenClouds)
               
           case Constants.WeatherType.fewClouds:
               weatherImageView.image = UIImage(systemName: Constants.WeatherImages.fewClouds)
               
           case Constants.WeatherType.lightRain:
               weatherImageView.image = UIImage(systemName: Constants.WeatherImages.lightRain)
               
           case Constants.WeatherType.overcastClouds:
               weatherImageView.image = UIImage(systemName: Constants.WeatherImages.overcastClouds)
               
           case Constants.WeatherType.rainy:
               weatherImageView.image = UIImage(systemName: Constants.WeatherImages.rainy)
               
           case Constants.WeatherType.snowy:
               weatherImageView.image = UIImage(systemName: Constants.WeatherImages.snowy)
               
           default:
               weatherImageView.image = UIImage(systemName: Constants.WeatherImages.defaultImage)
           }
           
           weatherImageView.contentMode = .scaleAspectFit
       }
}

extension UITableViewCell: WeatherImageSetup {}

extension UICollectionViewCell: WeatherImageSetup {}
