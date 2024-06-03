//
//  WeatherForecastView.swift
//  SwiftUIIntergrationProject
//
//  Created by Prateek Sujaina on 02/06/24.
//

import Foundation
import UIKit
import SnapKit
import RxSwift

final class WeatherForecastCVC: UICollectionViewCell {
    let disposeBag = DisposeBag()
    
    let lblTime: UILabel = UILabel.getLabel(fonrSize: 20, numberOfLines: -1)
    let lblTemp: UILabel = UILabel.getLabel(fonrSize: 16)
    let lblWeather: UILabel = UILabel.getLabel(fonrSize: 16, numberOfLines: -1)
    let lblWind: UILabel = UILabel.getLabel(fonrSize: 16)
    let lblWindDir: UILabel = UILabel.getLabel(fonrSize: 16)
    let lblRain: UILabel = UILabel.getLabel(fonrSize: 16)
    
    let containerView: UIView = UIView()
    
    init() {
        super.init(frame: .zero)
        initialSetup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialSetup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialSetup()
    }
    
    func initialSetup() {
        setupUI()
    }
    
    func setupUI() {
        contentView.addSubview(containerView)
        containerView.layer.borderWidth = 0.75
        containerView.snp.makeConstraints { make in
            make.edges.equalToSuperview().offset(12)
        }
        
        containerView.addSubview(lblTime)
        lblTime.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.trailing.equalToSuperview()
        }
        
        containerView.addSubview(lblTemp)
        lblTemp.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(lblTime.snp.bottom).offset(16)
        }
        
        containerView.addSubview(lblWeather)
        lblWeather.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(lblTemp.snp.bottom).offset(16)
        }
        
        containerView.addSubview(lblWind)
        lblWind.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(lblWeather.snp.bottom).offset(16)
        }
        
        containerView.addSubview(lblWindDir)
        lblWindDir.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(lblWind.snp.bottom).offset(16)
        }
        
        containerView.addSubview(lblRain)
        lblRain.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(lblWindDir.snp.bottom).offset(16)
            make.bottom.equalToSuperview().offset(-12)
        }
    }
    
    func updateWith(model: WeatherForecastViewModel) {
        lblTime.text = model.time
        lblTemp.text = model.temperature
        lblWeather.text = model.weather
        lblWind.text = model.wind
        lblWindDir.text = model.windDirection
        lblRain.text = model.rain
    }
}

extension WeatherForecastCVC {
    static var identifier: String { "WeatherForecastCVC" }
}

//MARK: ViewModel for WeatherForecastCVC

struct WeatherForecastViewModel {
    let time: String
    let temperature: String
    let weather: String
    let wind: String
    let windDirection: String
    let rain: String
}
