import Foundation

protocol LocationRequestPresenterDelegate: AnyObject {
    func locationAuthorizationApproved()
}

final class LocationRequestPresenter {
    
    weak var delegate: LocationRequestPresenterDelegate?
    
    let locationManager = LocationManager()
    
    
    func checkRequestStatus() {
        if locationManager.locationManager.authorizationStatus == .authorizedWhenInUse {
                delegate?.locationAuthorizationApproved()
            }
        }
    
}
