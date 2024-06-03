//
//  SwiftUIIntergrationProjectTests.swift
//  SwiftUIIntergrationProjectTests
//
//  Created by Yuchen Nie on 4/2/24.
//

import XCTest
@testable import SwiftUIIntergrationProject
import RxSwift
import RxBlocking

final class SwiftUIIntergrationProjectTests: XCTestCase {
    var networkService: NetworkMock!
    var vm: ViewModel!
    override func setUpWithError() throws {
        networkService = NetworkMock()
        vm = ViewModel(environment: Environment.mock(networkMock: networkService))
    }

    override func tearDownWithError() throws {
        networkService = nil
        vm = nil
    }

    func testCurrentWeatherFlow() throws {
        networkService.appendResponse(data: try Utils.getData(filename: "weather", ext: "json"))
        
        XCTAssertNil(vm.addressRelay.value, "Initially the address is nil")
        
        vm.addressRelay.accept("delhi")
        let result = try vm.curWeatherDriver.toBlocking().first()
        XCTAssertNotNil(result, "On address value updated, driver should emit an event")
    }
    
    func testWindDirectionString() {
        XCTAssertEqual(Wind(speed: 0, deg: 23).direction, "Northeast")
        XCTAssertEqual(Wind(speed: 0, deg: 67).direction, "Northeast")
        XCTAssertEqual(Wind(speed: 0, deg: 68).direction, "East")
        XCTAssertEqual(Wind(speed: 0, deg: 112).direction, "East")
        XCTAssertEqual(Wind(speed: 0, deg: 113).direction, "Southeast")
        XCTAssertEqual(Wind(speed: 0, deg: 157).direction, "Southeast")
        XCTAssertEqual(Wind(speed: 0, deg: 158).direction, "South")
        XCTAssertEqual(Wind(speed: 0, deg: 202).direction, "South")
        XCTAssertEqual(Wind(speed: 0, deg: 203).direction, "Southwest")
        XCTAssertEqual(Wind(speed: 0, deg: 247).direction, "Southwest")
        XCTAssertEqual(Wind(speed: 0, deg: 248).direction, "West")
        XCTAssertEqual(Wind(speed: 0, deg: 292).direction, "West")
        XCTAssertEqual(Wind(speed: 0, deg: 293).direction, "Northwest")
        XCTAssertEqual(Wind(speed: 0, deg: 337).direction, "Northwest")
        XCTAssertEqual(Wind(speed: 0, deg: 20).direction, "North")
        XCTAssertEqual(Wind(speed: 0, deg: 338).direction, "North")
    }
    
    func testCurrentWeatherViewModel() throws {
        networkService.appendResponse(data: try Utils.getData(filename: "weather", ext: "json"))
        vm.addressRelay.accept("delhi")
        let result = try vm.curWeatherDriver.toBlocking().first()
        XCTAssertNotNil(result)
        switch result! {
        case .success(let model):
            XCTAssertNotNil(model, "view model should not be nil")
            XCTAssertEqual(model!.weather, "Current weather: haze", "Unexpected weather description")
            XCTAssertEqual(model!.temperature, "Temperature: 105.22 F", "Unexpected temperature description")
            XCTAssertEqual(model!.wind, "Wind: 6.91 mph", "Unexpected wind description")
            XCTAssertEqual(model!.windDirection, "Wind direction: West", "Unexpected wind direction description")
        case .failure(_):
            XCTFail("Unexpected result")
        }
    }
    
    func testWeatherForecastFlow() throws {
        networkService.appendResponse(data: try Utils.getData(filename: "forecast", ext: "json"))
        
        // address value is nil initially
        XCTAssertNil(vm.addressRelay.value, "Initially the address is nil")
        let forecastHeader1 = try vm.forecastHeader.toBlocking().first()!
        XCTAssertNil(forecastHeader1, "Forecast header text should be nil")
        
        // address value updated
        vm.addressRelay.accept("delhi")
        let result = try vm.forecastDriver.toBlocking().first()
        XCTAssertNotNil(result, "On address value updated, driver should emit an event")
        XCTAssertTrue(!(result!.isEmpty), "Forecast data should be available")
        XCTAssertTrue(result!.count == 40)
    }
    
    func testForecastViewModel() throws {
        networkService.appendResponse(data: try Utils.getData(filename: "forecast", ext: "json"))
        vm.addressRelay.accept("delhi")
        let model = try vm.forecastDriver.toBlocking().first()?.first
        XCTAssertNotNil(model)
        XCTAssertEqual(model!.weather, "Weather: clear sky", "Unexpected weather description")
        XCTAssertEqual(model!.temperature, "Temperature: 61.2 F", "Unexpected temperature description")
        XCTAssertEqual(model!.wind, "Wind: 7.52 mph", "Unexpected wind description")
        XCTAssertEqual(model!.windDirection, "Wind direction: Southwest", "Unexpected wind direction description")
        XCTAssertEqual(model!.rain, "Rain: None", "Unexpected wind direction description")
    }
    
    func testWeatherForecastHeader() throws {
        networkService.appendResponse(data: try Utils.getData(filename: "forecast", ext: "json"))
        vm.addressRelay.accept("delhi")
        let forecastHeader2 = try vm.forecastHeader.toBlocking().first()!
        XCTAssertNotNil(forecastHeader2, "Forecast header text should not be nil")
        XCTAssertTrue(forecastHeader2! == "5 day forecast")
    }
}
