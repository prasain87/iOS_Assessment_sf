import Foundation
import RxSwift
import MapKit

  // TODO: Fill in this to retrieve current weather, and 5 day forecast by passing in a CLLocation
  ///ForecastJSONData and CurrentWeatherJSONData are the data types returned from Open Weather Service
struct WeatherService {
  /// Example function signatures. Takes in location and returns publishers that contain
//  var retrieveWeatherForecast: (CLLocation) -> DataPublisher<ForecastJSONData?>
//  var retrieveCurrentWeather: (CLLocation) -> DataPublisher<CurrentWeatherJSONData?>
    let networkService: NetworkService
}

extension WeatherService {
    static var live = WeatherService(networkService: NetworkServiceDefault())
}

extension WeatherService {
    func retrieveWeatherForecast(_ location: CLLocation) -> Observable<ForecastJSONData?> {
        guard let url = forecastURL(location: location) else {
            return .just(nil)
        }
        return networkService.data(url: url)
    }
    
    func retrieveCurrentWeather(_ location: CLLocation) -> Observable<CurrentWeatherJSONData?> {
        guard let url = currentWeatherURL(location: location) else {
            return .just(nil)
        }
        return networkService.data(url: url)
    }
}
