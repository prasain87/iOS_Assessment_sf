//
//  CurrentWeatherView.swift
//  SwiftUIIntergrationProject
//
//  Created by Prateek Sujaina on 02/06/24.
//

import UIKit
import RxSwift
import RxCocoa
import SnapKit

final class CurrentWeatherView: UIView {
    private let disposeBag = DisposeBag()
    var dataDriver: Driver<Result<CurrentWeatherViewModel?, Error>>!
    
    let lblTitle: UILabel = UILabel.getLabel(fonrSize: 26, numberOfLines: -1)
    let lblCurWeather: UILabel = UILabel.getLabel(fonrSize: 20, numberOfLines: -1)
    let lblTemp: UILabel = UILabel.getLabel(fonrSize: 20)
    let lblWind: UILabel = UILabel.getLabel(fonrSize: 20)
    let lblWindDir: UILabel = UILabel.getLabel(fonrSize: 20)
    
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
}

extension CurrentWeatherView {
    func initialSetup() {
        setupUI()
    }
    
    func createDataBinding() {
        dataDriver
            .drive(
                onNext: { [weak self] data in
                    self?.updateData(data)
                    print("data")
                },
                onCompleted: {
                    print("complete")
                },
                onDisposed: {
                    print("dispose")
                })
            .disposed(by: disposeBag)
    }
    
    func setupUI() {
        addSubview(lblTitle)
        lblTitle.snp.makeConstraints { make in
            make.leading.trailing.top.equalToSuperview()
        }
        
        addSubview(lblCurWeather)
        lblCurWeather.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(lblTitle.snp.bottom).offset(16)
        }
        
        addSubview(lblTemp)
        lblTemp.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(lblCurWeather.snp.bottom).offset(16)
        }
        
        addSubview(lblWind)
        lblWind.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(lblTemp.snp.bottom).offset(16)
        }
        
        addSubview(lblWindDir)
        lblWindDir.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(lblWind.snp.bottom).offset(16)
        }
    }
}

extension CurrentWeatherView {
    func updateData(_ result: Result<CurrentWeatherViewModel?, Error>) {
        switch result {
        case .success(let data):
            setData(data)
        case .failure(let error):
            resetUI()
            if let error = error as? SimpleError {
                lblTitle.text = error.displayMsg
            } else {
                lblTitle.text = error.localizedDescription
            }
        }
    }
    
    private func setData(_ data: CurrentWeatherViewModel?) {
        lblTitle.text = data?.title
        lblCurWeather.text = data?.weather
        lblTemp.text = data?.temperature
        lblWind.text = data?.wind
        lblWindDir.text = data?.windDirection
    }
    
    private func resetUI() {
        setData(nil)
    }
}

extension UILabel {
    static func getLabel(fonrSize: CGFloat, numberOfLines: Int = 1) -> UILabel {
        let lbl = UILabel()
        lbl.font = UIFont.systemFont(ofSize: fonrSize)
        lbl.numberOfLines = numberOfLines
        lbl.textAlignment = .center
        return lbl
    }
}

//MARK: ViewModel for CurrentWeatherView

struct CurrentWeatherViewModel {
    let title: String
    let weather: String
    let temperature: String
    let wind: String
    let windDirection: String
}

extension CurrentWeatherViewModel {
    init(data: CurrentWeatherJSONData) {
        title = data.name
        weather = "Current weather: " + (data.weather.first?.description ?? "")
        temperature = "Temperature: \(data.main.temp) F"
        wind = "Wind: \(data.wind.speed) mph"
        windDirection = "Wind direction: \(data.wind.direction)"
    }
}
