//
//  WeatherDisplayData.swift
//  SwiftUIIntergrationProject
//
//  Created by Yuchen Nie on 4/5/24.
//

import Foundation

// Generated from: https://app.quicktype.io/
struct ForecastJSONData: Codable, Equatable {
  let cod: String
  let message, cnt: Int
  let list: [List]
  let city: City
}

  // MARK: - City
struct City: Codable, Equatable  {
  let id: Int
  let name: String
}

  // MARK: - List
struct List: Codable, Equatable  {
  let dt: Int
  let temperatures: Temperature
  let weather: [Weather]
  let wind: Wind
  let rain: Rain?
  
  enum CodingKeys: String, CodingKey {
    case temperatures = "main"
    case dt, weather, wind
    case rain
  }
}

extension List {
  var displayDate: String {
    let timeInterval = Date(timeIntervalSince1970: TimeInterval(dt))
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .short
    dateFormatter.timeStyle = .short
    return dateFormatter.string(from: timeInterval)
  }
}

  // MARK: - MainClass
struct Temperature: Codable, Equatable  {
  let temp, feelsLike: Double
  let humidity: Int
  
  enum CodingKeys: String, CodingKey {
    case temp
    case feelsLike = "feels_like"
    case humidity
  }
}

  // MARK: - Rain
struct Rain: Codable, Equatable  {
  let the3H: Double
  
  enum CodingKeys: String, CodingKey {
    case the3H = "3h"
  }
}

  // MARK: - Weather
struct Weather: Codable, Equatable {
  let id: Int
  let main: MainEnum
  let description, icon: String
}

enum MainEnum: String, Codable {
  case clear = "Clear"
  case clouds = "Clouds"
  case rain = "Rain"
  case haze = "Haze"
  case snow = "Snow"
}

  // MARK: - Wind
struct Wind: Codable, Equatable {
  let speed: Double
  let deg: Int
}

extension Wind {
  var direction: String {
    if deg >= 23 && deg < 68 { return "Northeast" }
    if deg >= 68 && deg < 113 { return "East" }
    if deg >= 113 && deg < 158 { return "Southeast" }
    if deg >= 158 && deg < 203 { return "South" }
    if deg >= 203 && deg < 248 { return "Southwest" }
    if deg >= 248 && deg < 293 { return "West" }
    if deg >= 293 && deg < 338 { return "Northwest" }
    return "North"
  }
}
