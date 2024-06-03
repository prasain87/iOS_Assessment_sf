//
//  Mappers.swift
//  SwiftUIIntergrationProject
//
//  Created by Prateek Sujaina on 02/06/24.
//

import Foundation

extension CurrentWeatherJSONData {
    func mapToViewModel() -> CurrentWeatherViewModel {
        CurrentWeatherViewModel(
            title: name,
            weather: "Current weather: " + (weather.first?.description ?? ""),
            temperature: temperatureString(main.temp),
            wind: windString(wind.speed),
            windDirection: windDirectionString(wind.direction)
        )
    }
}

extension Array where Element == List {
    func mapToViewModel() -> [WeatherForecastViewModel] {
        map {
            WeatherForecastViewModel(
                time: $0.displayDate,
                temperature: temperatureString($0.temperatures.temp),
                weather: "Weather: " + ($0.weather.first?.description ?? ""),
                wind: windString($0.wind.speed),
                windDirection: windDirectionString($0.wind.direction),
                rain: $0.rain.map({ "Rain: \($0.the3H) inches" }) ?? "Rain: None"
            )
        }
    }
}

private func temperatureString(_ val: Double) -> String {
    "Temperature: \(val) F"
}

private func windString(_ val: Double) -> String {
    "Wind: \(val) mph"
}

private func windDirectionString(_ val: String) -> String {
    "Wind direction: " + val
}
