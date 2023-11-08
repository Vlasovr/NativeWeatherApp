import UIKit

class DailyForecastTableViewCell: UITableViewCell {
    
    static var identifier: String { "\(Self.self)" }
    
    private lazy var weekdayLabel = UILabel()
    
    private var weatherImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleToFill
        iv.clipsToBounds = true
        return iv
    }()
    
    private lazy var windSpeedLabel = UILabel()

    private lazy var humidityLabel = UILabel()
    
    private lazy var temperatureLabel = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .lightGray
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        weekdayLabel.text = nil
        weatherImageView.image = nil
        windSpeedLabel.text = nil
        humidityLabel.text = nil
        temperatureLabel.text = nil
    }
    
    func configure(model: ForecastCellModel) {
        weekdayLabel.text = model.weekDay
        setupWeatherImage(with: model, weatherImageView: weatherImageView)
        windSpeedLabel.text = model.speed + Constants.DailyForecastTableViewCell.windSpeedMeasure
        humidityLabel.text = model.humidity + Constants.DailyForecastTableViewCell.humidityMeasure
        temperatureLabel.text = model.temperature + Constants.DailyForecastTableViewCell.degreesMeasure
    }
    
    private func addSubviews() {
        contentView.addSubview(weekdayLabel)
        contentView.addSubview(weatherImageView)
        contentView.addSubview(windSpeedLabel)
        contentView.addSubview(humidityLabel)
        contentView.addSubview(temperatureLabel)
    }
    
    private func setupConstraints() {
        
        weekdayLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(Constants.Offsets.small)
            make.top.equalToSuperview().offset(Constants.Offsets.small)
        }
        
        weatherImageView.snp.makeConstraints { make in
            make.left.equalTo(Constants.Offsets.large + Constants.Offsets.small)
            make.width.equalTo(Constants.Offsets.big + Constants.Offsets.medium)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        windSpeedLabel.snp.makeConstraints { make in
            make.left.equalTo(weatherImageView.snp.right).offset(Constants.Offsets.big)
            make.top.equalToSuperview().offset(Constants.Offsets.small)
        }
        
        humidityLabel.snp.makeConstraints { make in
            make.left.equalTo(windSpeedLabel.snp.right).offset(Constants.Offsets.big)
            make.top.equalToSuperview().offset(Constants.Offsets.small)
        }
        
        temperatureLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-Constants.Offsets.small)
            make.top.equalToSuperview().offset(Constants.Offsets.small)
        }
    }
}
