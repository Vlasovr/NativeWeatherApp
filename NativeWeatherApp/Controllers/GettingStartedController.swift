import UIKit

class GettingStartedController: UIViewController {
    
    private let enterButton = {
        let button = UIButton()
        button.setTitle(Constants.GettingStartedController.warning, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.titleLabel?.numberOfLines = 0
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(enterWeatherScreen), for: .touchUpInside)
        return button
    }()
    
    let viewModel: GettingStartedViewModel!
    
    init(viewModel: GettingStartedViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.viewModel = GettingStartedViewModel()
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        super.loadView()
        if viewModel.locationManager.getLocation() != nil {
            enterWeatherScreen()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .cyan
        view.addSubview(enterButton)
        setupConstraints()
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        enterButton.roundCorners()
        enterButton.dropShadow()
    }
    
    @objc func enterWeatherScreen() {
        let viewModel = WeatherViewModel(networkService: viewModel.networkService)
        let weatherController = WeatherController(viewModel: viewModel)
        navigationController?.pushViewController(weatherController, animated: true)
    }
    
    private func setupConstraints() {
        enterButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.width.equalTo(Constants.GettingStartedController.enterButtonWidth)
            make.height.equalTo(Constants.GettingStartedController.enterButtonHeight)
        }
    }
}

