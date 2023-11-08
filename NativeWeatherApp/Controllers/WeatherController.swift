import UIKit
import SnapKit

class WeatherController: UIViewController {
    
    private let presenter = WeatherForecastPresenter()
    
    private lazy var hourlyForecastCollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .lightGray
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(HourlyForecastCollectionViewCell.self,
                                forCellWithReuseIdentifier: HourlyForecastCollectionViewCell.identifier)
        return collectionView
    }()
    
    private lazy var dailyForecastTableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .lightGray
        tableView.showsVerticalScrollIndicator = false
        tableView.register(DailyForecastTableViewCell.self, forCellReuseIdentifier: DailyForecastTableViewCell.identifier)
        return tableView
    }()

    private lazy var contentView = UIView()
    
    private lazy var currentWeatherLabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = .zero
        return label
    }()
    
    private var perHourWeatherDataSource = [ForecastCellModel]()
    private var perDayWeatherDataSource = [ForecastCellModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hourlyForecastCollectionView.roundCorners()
        dailyForecastTableView.roundCorners()
        setupLaunchScreen()
    }
    
    private func setupUI() {
        navigationController?.navigationBar.isHidden = true
        addSubviews()
        setupConstraints()

        setDelegate()
        presenter.loadWeatherData()
    }

    private func setDelegate() {
        presenter.delegate = self
    }
    
    private func setupLaunchScreen() {
        let backgroundView = UIView(frame: view.frame)
        backgroundView.backgroundColor = .cyan
        view.addSubview(backgroundView)
        
        let cloudImageView = UIImageView(image: UIImage(systemName: Constants.WeatherController.cloudImage))
        cloudImageView.frame = CGRect(x: view.frame.origin.x,
                                      y: view.center.y - view.frame.width / 2,
                                      width: view.frame.width,
                                      height: Constants.WeatherController.cloudImageHeight)
        backgroundView.addSubview(cloudImageView)
        
        UIView.animate(withDuration: Constants.WeatherController.animationDuration) {
            backgroundView.alpha = .zero
        } completion: { _ in
            backgroundView.removeFromSuperview()
        }
    }
    
    private func setupWeatherForecast(_ weatherData: WeatherData) {
        setupCurrentWeatherLabel(weatherData)
        let weatherDataList = weatherData.list
        self.configureCollectionDataSource(weatherDataList)

        if let currentWeather = weatherDataList.first,
           let currentWeather {
            self.setupCurrentWeatherBackground(currentWeather)
        }
        reloadData()
    }
    
    private func configureCollectionDataSource(_ weatherDataList: [Weather?]) {
        weatherDataList.forEach { [weak self] weather in
            if let weather {
          
                if let description = weather.weather.first?.description,
                   let weekday = self?.presenter.configureWeekday(weather) {
                    let temperatureString = String(Int(weather.main.temp))
                    let temperatureFeelingString = String(Int(weather.main.feels_like))
                    
                    let humidityString = String(weather.main.humidity)
                    let speedString = String(weather.wind.speed)
                    
                    let cellModel = ForecastCellModel(temperature: temperatureString,
                                                      temperatureFeeling: temperatureFeelingString,
                                                      date:  weather.dt_txt, 
                                                      weekDay: weekday,
                                                      description: description,
                                                      humidity: humidityString,
                                                      speed: speedString)
                    self?.perHourWeatherDataSource.append(cellModel)
                    
                    
                    if !(weekday == self?.perDayWeatherDataSource.last?.weekDay) {
                        self?.perDayWeatherDataSource.append(cellModel)
                    }
                }
            }
        }
    }
    
    private func setupCurrentWeatherLabel(_ weather: WeatherData) {
        let place = (weather.city?.name ?? Constants.WeatherController.defaultPlace)
        
        if let currentWeather = weather.list.first,
           let temp = currentWeather?.main.temp,
           let description = currentWeather?.weather.first?.description.localized,
           let temperatureFeelsLike = currentWeather?.main.feels_like {
            
            let attributedText = NSMutableAttributedString()
            
            let regularFont = UIFont.systemFont(ofSize: Constants.FontSizes.medium)
            let bigFont = UIFont.boldSystemFont(ofSize: Constants.FontSizes.large)
            let temperatureFont = UIFont.boldSystemFont(ofSize: Constants.FontSizes.temperatureFont)
            
            let placeAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: bigFont]
            let tempAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: temperatureFont]
            let descriptionAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: regularFont]
            let feelsLikeAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: regularFont]
            
            attributedText.append(NSAttributedString(string: place  + Constants.WeatherController.nextStroke, attributes: placeAttributes))
            attributedText.append(NSAttributedString(string: String(Int(temp)) + Constants.WeatherController.degreesMeasure  + Constants.WeatherController.nextStroke, attributes: tempAttributes))
            attributedText.append(NSAttributedString(string: description + Constants.WeatherController.nextStroke, attributes: descriptionAttributes))
            attributedText.append(NSAttributedString(string: Constants.WeatherController.feelsLikeText + String(Int(temperatureFeelsLike)), attributes: feelsLikeAttributes))

            currentWeatherLabel.attributedText = attributedText
        }
    }
    
    private func reloadData() {
        hourlyForecastCollectionView.reloadData()
        dailyForecastTableView.reloadData()
    }
}

extension WeatherController: WeatherPresenterDelegate {
    func setupWeatherData(data: WeatherData) {
        DispatchQueue.main.async {
            self.setupWeatherForecast(data)
        }
    }
}

extension WeatherController {
    func addSubviews() {
        view.addSubview(contentView)
        contentView.addSubview(currentWeatherLabel)
        contentView.addSubview(hourlyForecastCollectionView)
        contentView.addSubview(dailyForecastTableView)
    }
    
    func setupConstraints() {
        
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        currentWeatherLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(Constants.Offsets.big)
            make.centerX.equalToSuperview()
        }
        
        hourlyForecastCollectionView.snp.makeConstraints { make in
            make.top.equalTo(currentWeatherLabel.snp.bottom).offset(Constants.Offsets.big)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(Constants.Offsets.medium)
            make.height.equalTo(Constants.WeatherController.collectionViewHeight)
        }
        
        if let layout = hourlyForecastCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
        }
        
        dailyForecastTableView.snp.makeConstraints { make in
            make.top.equalTo(hourlyForecastCollectionView.snp.bottom).offset(Constants.Offsets.big)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(Constants.Offsets.medium)
            make.height.equalTo(Constants.WeatherController.tableViewHeight)
        }
    }
}

extension WeatherController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        perHourWeatherDataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HourlyForecastCollectionViewCell.identifier,
                                                            for: indexPath) as? HourlyForecastCollectionViewCell else {
            return HourlyForecastCollectionViewCell()
        }
        
        cell.configure(model: perHourWeatherDataSource[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return Constants.WeatherController.collectionViewLayout
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        Constants.Offsets.small
    }
}

extension WeatherController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        perDayWeatherDataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: DailyForecastTableViewCell.identifier,
                                                       for: indexPath) as? DailyForecastTableViewCell else {
            return DailyForecastTableViewCell()
        }
        
        cell.configure(model: perDayWeatherDataSource[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        Constants.WeatherController.tableViewCellHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

private extension WeatherController {
    func setupCurrentWeatherBackground(_ weather: Weather) {
        let weatherDescription = weather.weather.first?.description
        switch weatherDescription {
            
        case Constants.WeatherType.brokenClouds:
            view.backgroundColor = .gray
            
        case Constants.WeatherType.clearSky:
            view.backgroundColor = .cyan
            
        case Constants.WeatherType.fewClouds:
            view.backgroundColor = .blue
            
        case Constants.WeatherType.rainy:
            view.backgroundColor = .darkGray
            
        case Constants.WeatherType.snowy:
            view.backgroundColor = .lightGray
            
        default:
            break
            
        }
    }
}
