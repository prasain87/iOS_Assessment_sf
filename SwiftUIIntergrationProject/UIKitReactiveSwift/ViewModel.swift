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
    var addressPlaceholder: String { get }
    var addressRelay: BehaviorRelay<String?> { get }
    var curWeatherDriver: Driver<Result<CurrentWeatherViewModel?, Error>> { get }
    var forecastDriver: Driver<[WeatherForecastViewModel]> { get }
    var forecastHeader: Driver<String?> { get }
}

final class ViewModel: ViewModelProtocol {
    let disposeBag = DisposeBag()

    let addressRelay = BehaviorRelay<String?>(value: nil)
    let curWeatherDriver: Driver<Result<CurrentWeatherViewModel?, Error>>
    
    let forecastDriver: Driver<[WeatherForecastViewModel]>
    let forecastHeader: Driver<String?>
    let addressPlaceholder: String = "Enter City Here"
    
    private let environment: Environment
    
    init(environment: Environment) {
        self.environment = environment
        let locationObservable = addressRelay
            .asObservable()
            .debounce(RxTimeInterval.milliseconds(300), scheduler: ConcurrentDispatchQueueScheduler(qos: .background))
            .flatMapLatest({ address -> Observable<Result<CLLocation?, Error>> in
                guard let address, !address.isEmpty else {
                    return .just(.success(nil))
                }
                return environment.addressService.coordinateRX(address)
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
                    return environment.weatherServiceReactive.retrieveCurrentWeather(location)
                        .map({ .success($0?.mapToViewModel()) })
                        .catch({ Observable.just(.failure($0)) })
                case .failure(let err):
                    return .just(.failure(err))
                }
            })
            .catch({ .just(.failure($0)) })
            .asDriver(onErrorRecover: { Driver.just(.failure($0)) })
        
        let forecastResult = locationObservable
            .flatMapLatest({ result -> Observable<Result<[WeatherForecastViewModel], Error>> in
                switch result {
                case .success(let location):
                    guard let location else {
                        return .just(.success([]))
                    }
                    return environment.weatherServiceReactive.retrieveWeatherForecast(location)
                        .map({ data in
                                .success(data.map({ $0.list.mapToViewModel() }) ?? [])
                        })
                        .catch({ Observable.just(.failure($0)) })
                case .failure(let err):
                    return .just(.failure(err))
                }
            })
            .asDriver(onErrorRecover: { Driver.just(.failure($0)) })
        
        forecastDriver = forecastResult.map({
            switch $0 {
            case .success(let data):
                return data
            case .failure(_):
                return []
            }
        })
        
        forecastHeader = forecastResult.map({
            switch $0 {
            case .success(let data):
                return data.isEmpty ? nil : "5 day forecast"
            case .failure(let err):
                return if let error = err as? SimpleError {
                    error.displayMsg
                } else {
                    "Something went wrong, please try again later!"
                }
            }
        })
    }
}
