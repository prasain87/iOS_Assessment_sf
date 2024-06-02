//
//  Mappers.swift
//  SwiftUIIntergrationProject
//
//  Created by Prateek Sujaina on 02/06/24.
//

import Foundation

extension CurrentWeatherJSONData {
    func mapToViewModel() -> CurrentWeatherViewModel {
        CurrentWeatherViewModel(data: self)
    }
}
