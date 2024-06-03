//
//  EnvironmentMock.swift
//  SwiftUIIntergrationProject
//
//  Created by Yuchen Nie on 4/9/24.
//

import Foundation
import ReactiveSwift

@testable import SwiftUIIntergrationProject

extension Environment {
    static func mock(networkMock: NetworkMock) -> Environment {
        Environment(
            scheduler: TestScheduler(),
            backgroundScheduler: TestScheduler(),
            runLoop: .init(),
            weatherServiceReactive: WeatherService(networkService: networkMock),
            addressService: .mock
        )
    }
}
