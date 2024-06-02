//
//  ViewModel.swift
//  SwiftUIIntergrationProject
//
//  Created by Prateek Sujaina on 02/06/24.
//

import RxSwift
import RxCocoa
import CoreLocation

protocol ViewModelProtocol {
    var addressRelay: PublishRelay<String?> { get }
    var curWeatherDriver: Driver<Result<CurrentWeatherViewModel?, Error>> { get }
    var forecastDriver: Driver<[WeatherForecastViewModel]> { get }
    var hideForecastDriver: Driver<Bool> { get }
}

final class ViewModel: ViewModelProtocol {
    let disposeBag = DisposeBag()

    let addressRelay = PublishRelay<String?>()
    let curWeatherDriver: Driver<Result<CurrentWeatherViewModel?, Error>>
    
    let forecastDriver: Driver<[WeatherForecastViewModel]>
    let hideForecastDriver: Driver<Bool>
    
    init() {
        let locationObservable = addressRelay
            .asObservable()
            .debounce(RxTimeInterval.milliseconds(200), scheduler: MainScheduler.asyncInstance)
            .flatMapLatest({ address -> Observable<Result<CLLocation?, Error>> in
                guard let address, !address.isEmpty else {
                    return .just(.success(nil))
                }
                return AddressService.live.coordinateRX(address)
                    .map({.success($0)})
                    .catch({ Observable.just(.failure($0)) })
            })
            .share()
        
        curWeatherDriver = locationObservable
            .flatMapLatest({ result -> Observable<Result<CurrentWeatherViewModel?, Error>> in
                switch result {
                case .success(let location):
                    guard let location else {
                        return .just(.success(nil))
                    }
                    return WeatherService.live.retrieveCurrentWeather(location)
                        .map({ .success($0?.mapToViewModel()) })
                        .catch({ Observable.just(.failure($0)) })
                case .failure(let err):
                    return .just(.failure(err))
                }
            })
            .catch({ error in
                    .just(.failure(error))
            })
            .asDriver(onErrorRecover: { error in
                Driver.just(.failure(error))
            })
        
        forecastDriver = locationObservable
            .flatMapLatest({ result -> Observable<ForecastJSONData?> in
                switch result {
                case .success(let location):
                    guard let location else {
                        return .just(nil)
                    }
                    return WeatherService.live.retrieveWeatherForecast(location)
                case .failure(_):
                    return .just(nil)
                }
            })
            .map({ data in
                return if let data {
                    data.list.map({ WeatherForecastViewModel(data: $0) })
                } else {
                    []
                }
            })
            .asDriver(onErrorJustReturn: [])
        
        hideForecastDriver = forecastDriver.map({ $0.isEmpty })
    }
}
