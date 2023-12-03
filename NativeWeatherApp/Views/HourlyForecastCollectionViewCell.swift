import UIKit

final class HourlyForecastCollectionViewCell: UICollectionViewCell {
    
    static var identifier: String { "\(Self.self)" }
    
    private var weatherImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleToFill
        iv.clipsToBounds = true
        return iv
    }()
    
    private lazy var dateLabel = UILabel()
    private lazy var temperatureLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubviews()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        weatherImageView.image = nil
        dateLabel.text = nil
        temperatureLabel.text = nil
    }
    
    func configure(model: ForecastCellModel) {
        let dateFormattedText = String(model.date.dropFirst(Constants.HourlyForecastTableViewCell.firstrCharactersToDrop).dropLast(Constants.HourlyForecastTableViewCell.lastCharactersToDrop))
        
        dateLabel.text = dateFormattedText
        setupWeatherImage(with: model, weatherImageView: weatherImageView)
        temperatureLabel.text = model.temperature + Constants.HourlyForecastTableViewCell.degreesMeasure
    }
    
    private func addSubviews() {
        contentView.addSubview(dateLabel)
        contentView.addSubview(weatherImageView)
        contentView.addSubview(temperatureLabel)
    }
    
    private func setupConstraints() {
        dateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(-Constants.Offsets.medium)
            make.centerX.equalToSuperview()
        }
        
        weatherImageView.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom)
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.bottom.equalToSuperview().offset(-Constants.Offsets.small)
        }
        
        temperatureLabel.snp.makeConstraints { make in
            make.top.equalTo(weatherImageView.snp.bottom).offset(Constants.Offsets.small)
            make.centerX.equalTo(contentView.snp.centerX)
        }
    }
}

