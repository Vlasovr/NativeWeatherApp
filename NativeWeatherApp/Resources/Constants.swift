import Foundation

enum Constants {
    
    enum Offsets {
        static let layoutMargin = 20.0
        static let small = 8.0
        static let medium = 16.0
        static let big = 32.0
        static let large = 64.0
        static let hyper = 128.0
        static let textFieldGoingUpBottomOffset = 200.0
        
    }

    enum FontSizes {
        static let small = 10.0
        static let medium = 20.0
        static let large = 30.0
        static let hyper = 40.0
        static let temperatureFont = 80.0
    }
    
    enum WeatherController {
        
        static let cloudImage = "cloud.sun.fill"
        static let cloudImageHeight = 300.0
        static let animationDuration = 3.0
        
        static let lastCharactersToDrop = 9
        static let dateFormat = "yyyy-MM-dd"
        static let dateFormatterLocale = "ru"
        
        static let defaultPlace = "Текущее место"
        static let degreesMeasure = "°"
        static let nextStroke = "\n"
        static let feelsLikeText = "feels like "
        static let collectionViewHeight = 100.0
        static let collectionViewLayout = CGSize(width: 40, height: 60)
        
        static let tableViewCellHeight = 45.0
        static let tableViewHeight = 270.0
    }
    
    enum WeatherType {
        static let clearSky = "clear sky"
        static let fewClouds = "few clouds"
        static let brokenClouds = "broken clouds"
        static let lightRain = "light rain"
        static let overcastClouds = "overcast clouds"
        static let scatteredClouds = "overcast clouds"
        static let rainy = "rainy"
        static let snowy = "snowy"
    }
    
    enum WeatherImages {
        static let clearSky = "sun.max.circle.fill"
        static let fewClouds = "cloud.sun.fill"
        static let brokenClouds = "cloud.fill"
        static let lightRain = "cloud.rain.fill"
        static let overcastClouds = "cloud.bolt.fill"
        static let scatteredClouds = "cloud.moon.fill"
        static let rainy = "cloud.heavyrain.fill"
        static let snowy = "cloud.snow.fill"
        static let defaultImage = "smoke.fill"
    }
    
    enum LocationController {
        static let lastCharactersToDrop = 9
        static let dateFormat = "yyyy-MM-dd"
        static let dateFormatterLocale = "ru"
    }
    
    enum UIViewExtension {
        static let shadowOpacity: Float = 0.5
        static let shadowOffset = CGSize(width: 5, height: 5)
        static let shadowRadius: CGFloat = 5
        static let radius = 10.0
    }
    
    enum Localization {
        static let localizedComment = ""
    }
    
    enum DailyForecastTableViewCell {
        static let windSpeedMeasure = "км/ч"
        static let humidityMeasure = "%"
        static let degreesMeasure = "°"
    }
    
    enum HourlyForecastTableViewCell {
        static let firstrCharactersToDrop = 10
        static let lastCharactersToDrop = 6
        static let degreesMeasure = "°"
    }
}
