import UIKit
import SnapKit
import MapKit

class ViewController: UIViewController {
    
    var map = MKMapView()
    
    private lazy var weatherDescriptionLabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var button = {
       let button = UIButton()
        button.setTitle("Sunny".localized, for: .normal)
        button.backgroundColor = .green
        return button
    }()

    let networkService = NetworkService()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        view.addSubview(button)
        view.addSubview(weatherDescriptionLabel)
        
        weatherDescriptionLabel.snp.makeConstraints { make in
            make.height.equalToSuperview()
            make.width.equalToSuperview()
        }
        
        button.snp.makeConstraints { make in
                  make.left.equalTo(view.snp.left).offset(100)
                  make.top.equalTo(view.snp.top).offset(100)
        }
        
        networkService.getWeather { [weak self] data in
            if let data {
                DispatchQueue.main.async {
                    self?.setupUI(with: data)
                }
                
            }
        }
    //    setupMap()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupLaunchScreen()
    }
    
    private func setupLaunchScreen() {
        let backgroundView = UIView(frame: view.frame)
        backgroundView.backgroundColor = .cyan
        view.addSubview(backgroundView)
        
        let cloudImageView = UIImageView(image: UIImage(systemName: "cloud.sun.fill"))
        cloudImageView.frame = CGRect(x: view.frame.origin.x,
                                      y: view.center.y - view.frame.width / 2,
                                      width: view.frame.width,
                                      height: 300)
        backgroundView.addSubview(cloudImageView)
        
        UIView.animate(withDuration: 23) {
            backgroundView.alpha = .zero
        } completion: { _ in
            backgroundView.removeFromSuperview()
        }
    }
    
    func setupMap() {
        map = MKMapView(frame: view.frame)
        map.showsUserLocation = true
        map.delegate = self
        view = map
        let tap = UITapGestureRecognizer(target: self, action: #selector(pressDetected(_:)))
        view.addGestureRecognizer(tap)
        if let location = LocationManager.shared.locationManager.location {
            map.centerToLocation(location)
        }
    }
    
    @objc func pressDetected(_ sender: UITapGestureRecognizer) {
        if sender.state != UIGestureRecognizer.State.began { return }
        let touchLocation = sender.location(in: map)
        let coordinate = map.convert(touchLocation, toCoordinateFrom: map)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "I was here"
        annotation.subtitle = "\(coordinate.longitude) \(coordinate.latitude)"
        map.addAnnotation(annotation)
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

extension MKMapView {
    
    func centerToLocation(_ location: CLLocation, regionRadius: CLLocationDistance = 1000) {
        let region = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        setRegion(region, animated: true)
        
    }
}

extension ViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "annotationView")
        annotationView.canShowCallout = true
        annotationView.rightCalloutAccessoryView = UIButton.init(type: UIButton.ButtonType.detailDisclosure)

        return annotationView
    }

    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let annotation = view.annotation else
        {
            return
        }

        let urlString = "http://maps.apple.com/?sll=\(annotation.coordinate.latitude),\(annotation.coordinate.longitude)"
        guard let url = URL(string: urlString) else
        {
            return
        }

        UIApplication.shared.openURL(url)
    }
}
