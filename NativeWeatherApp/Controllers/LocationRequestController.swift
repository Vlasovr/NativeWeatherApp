import UIKit

class LocationRequestController: UIViewController {
    
    let presenter = LocationRequestPresenter()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        navigateToMainScreen()
    }
    
    private func setupUI() {
        setDelegate()
    }
    
    private func navigateToMainScreen() {
        presenter.checkRequestStatus()
    }
    
    private func setDelegate() {
        presenter.delegate = self
    }
}

extension LocationRequestController: LocationRequestPresenterDelegate {
    func locationAuthorizationApproved() {
        DispatchQueue.main.async {
            let controller = WeatherController()
            self.navigationController?.pushViewController(controller, animated: true)
        }
    }
}
