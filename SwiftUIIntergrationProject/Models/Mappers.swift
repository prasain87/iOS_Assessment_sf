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
            temperature: "Temperature: \(main.temp) F",
            wind: "Wind: \(wind.speed) mph",
            windDirection: "Wind direction: \(wind.direction)"
        )
    }
}

extension Array where Element == List {
    func mapToViewModel() -> [WeatherForecastViewModel] {
        map {
            WeatherForecastViewModel(
                time: $0.displayDate,
                temperature: "Temperature: \($0.temperatures.temp) F",
                weather: "Weather: " + ($0.weather.first?.description ?? ""),
                wind: "Wind: \($0.wind.speed) mph",
                windDirection: "Wind direction: \($0.wind.direction)",
                rain: $0.rain.map({ "Rain: \($0.the3H) inches" }) ?? "Rain: No rain"
            )
        }
    }
}
