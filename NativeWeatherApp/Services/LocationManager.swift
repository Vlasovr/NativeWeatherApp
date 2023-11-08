import Foundation
import CoreLocation

final class LocationManager: NSObject, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    
    var location: CLLocation?
    
    override init() {
        super.init()
        locationManager.delegate = self
        requestLocation()
    }
    
    func requestLocation() {
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        self.location = location
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func getLocation() -> String? {
        
        guard let latitude = getLatitude(),
              let longitude = getLongitude() else { return nil }
        return "lat=" + latitude + "&" +
        "lon=" + longitude
    }
    
    private func getLatitude() -> String? {
        guard let location else { return nil}
        return "\(location.coordinate.latitude)"
        
    }
    
    private func getLongitude() -> String? {
        guard let location else { return nil}
        return "\(location.coordinate.longitude)"
    }
    
    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
    }
}


