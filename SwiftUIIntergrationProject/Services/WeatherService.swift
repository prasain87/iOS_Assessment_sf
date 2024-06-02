import Foundation
import RxSwift
import MapKit

  // TODO: Fill in this to retrieve current weather, and 5 day forecast by passing in a CLLocation
  ///ForecastJSONData and CurrentWeatherJSONData are the data types returned from Open Weather Service
struct WeatherService {
  /// Example function signatures. Takes in location and returns publishers that contain
//  var retrieveWeatherForecast: (CLLocation) -> DataPublisher<ForecastJSONData?>
//  var retrieveCurrentWeather: (CLLocation) -> DataPublisher<CurrentWeatherJSONData?>
}

extension WeatherService {
  static var live = WeatherService()
}

extension WeatherService {
    func retrieveWeatherForecast(_ location: CLLocation) -> Observable<ForecastJSONData?> {
        guard let url = forecastURL(location: location) else {
            return .just(nil)
        }
        return data(url: url)
    }
    
    func retrieveCurrentWeather(_ location: CLLocation) -> Observable<CurrentWeatherJSONData?> {
        guard let url = currentWeatherURL(location: location) else {
            return .just(nil)
        }
        return data(url: url)
    }
    
    func data<T: Decodable>(url: URL) -> Observable<T?> {
        let request: URLRequest = URLRequest(url: url)
        return Observable.create { obs in
            let task = URLSession.shared.dataTask(with: request) { data, rsp, error in
                if let error {
                    obs.onError(SimpleError.dataLoad(error.localizedDescription))
                } else if let data {
                    do {
                        let decoded = try JSONDecoder().decode(T.self, from: data)
                        obs.onNext(decoded)
                    } catch {
                        obs.onError(SimpleError.dataParse(error.localizedDescription))
                        print(error)
                    }
                } else {
                    obs.onNext(nil)
                }
                obs.onCompleted()
            }
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
    }
}
