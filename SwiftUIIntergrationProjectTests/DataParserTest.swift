//
//  DataParserTest.swift
//  SwiftUIIntergrationProjectTests
//
//  Created by Prateek Sujaina on 02/06/24.
//

import XCTest
@testable import SwiftUIIntergrationProject
import CoreLocation
//import RxSwift
import RxBlocking

final class DataParserTest: XCTestCase {
    var networkService: NetworkMock!
    var weatherService: WeatherService!
    
    override func setUpWithError() throws {
        networkService = NetworkMock()
        weatherService = WeatherService(networkService: networkService)
    }
    
    override func tearDownWithError() throws {
        networkService = nil
        weatherService = nil
    }

    func testWeatherDataParsing() throws {
//        let url = Bundle(for: type(of: self).self).url(forResource: "weather", withExtension: "json")!
//        let data = try Data(contentsOf: url)
        networkService.appendResponse(data: try Utils.getData(filename: "weather", ext: "json"))
        
        let obj = try weatherService.retrieveCurrentWeather(CLLocation(latitude: 0, longitude: 0)).toBlocking().first()!
        XCTAssertTrue(obj != nil, "Parsing failed for weather response")
    }
    
    func testForcastDataParsing() throws {
//        let url = Bundle(for: type(of: self).self).url(forResource: "forecast", withExtension: "json")!
//        let data = try Data(contentsOf: url)
        networkService.appendResponse(data: try Utils.getData(filename: "forecast", ext: "json"))
        
        let obj = try weatherService.retrieveWeatherForecast(CLLocation(latitude: 0, longitude: 0)).toBlocking().first()!
        XCTAssertTrue(obj != nil, "Parsing failed for forecast response")
    }
}
