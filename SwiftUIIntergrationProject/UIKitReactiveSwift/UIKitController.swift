//
//  UIKitReactiveController.swift
//  SwiftUIIntergrationProject
//
//  Created by Yuchen Nie on 4/5/24.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa

// TODO: Create UIKit View that either pre-selects address or user enters address, and retrieves current weather plus weather forecast
final class UIKitController: UIViewController {
    private var cellHeight: CGFloat { (2*view.bounds.width)/3 }
    
    let disposeBag = DisposeBag()
    
    private let addressTextField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .roundedRect
        tf.clearButtonMode = .always
        tf.placeholder = "Enter City Here"
        return tf
    }()
    private let curWeatherView = CurrentWeatherView()
    private let labelForecast: UILabel = {
        let lbl = UILabel.getLabel(fonrSize: 26)
        lbl.isHidden = true
        return lbl
    }()
    
    private let forecastCollectinoView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(WeatherForecastCVC.self, forCellWithReuseIdentifier: WeatherForecastCVC.identifier)
        return cv
    }()
    
    var viewModel: ViewModelProtocol = ViewModel(environment: Environment.current)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupUI()
        dataBinding()
        addressTextField.becomeFirstResponder()
    }
    
    func setupUI() {
        addressTextField.placeholder = viewModel.addressPlaceholder
        view.addSubview(addressTextField)
        addressTextField.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
        }
        
        view.addSubview(curWeatherView)
        curWeatherView.dataDriver = viewModel.curWeatherDriver
        curWeatherView.createDataBinding()
        curWeatherView.snp.makeConstraints { make in
            make.leading.greaterThanOrEqualToSuperview().offset(16)
            make.trailing.greaterThanOrEqualToSuperview().offset(-16)
            make.top.equalTo(addressTextField.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
        }

        view.addSubview(labelForecast)
        labelForecast.snp.makeConstraints { make in
            make.top.equalTo(curWeatherView.snp.bottom).offset(40)
            make.leading.trailing.equalToSuperview()
        }
        
        forecastCollectinoView.delegate = self
        view.addSubview(forecastCollectinoView)
        forecastCollectinoView.snp.makeConstraints { make in
            make.top.equalTo(labelForecast.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    func dataBinding() {
        addressTextField.rx.text
            .bind(to: viewModel.addressRelay)
            .disposed(by: disposeBag)
        
        viewModel
            .forecastDriver
            .drive(forecastCollectinoView.rx.items(cellIdentifier: WeatherForecastCVC.identifier, cellType: WeatherForecastCVC.self)) { index, model, cell in
            cell.updateWith(model: model)
        }
        .disposed(by: disposeBag)
        
        viewModel.forecastHeader
            .drive(labelForecast.rx.text)
            .disposed(by: disposeBag)
    }
}

extension UIKitController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.bounds.width/2, height: cellHeight)
    }
}
