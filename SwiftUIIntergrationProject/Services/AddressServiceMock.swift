//
//  AddressServiceMock.swift
//  SwiftUIIntergrationProjectTests
//
//  Created by Yuchen Nie on 4/10/24.
//

import Foundation
import MapKit
import ReactiveSwift
import Combine
import RxSwift

@testable import SwiftUIIntergrationProject

extension AddressService {
    static var mock = AddressService(
        asyncCoordinate: asyncCoordinateMock,
//        coordinatePublisher: coordinatePubMock,
        coordinateRX: coordinateObservableMock,
        coordinatesCompletion: coordinatesCompMock
    )
}

extension AddressService {
  static func asyncCoordinateMock(from address: String) async -> CLLocation? {
    return .init(latitude: 0, longitude: 0)
  }
  
//  static func coordinatePubMock(from address: String) -> AnyPublisher<CLLocation?, SimpleError> {
//    Just(CLLocation.init(latitude: 0, longitude: 0)).eraseToAnyPublisher()
//  }
  
//  static func coordinatesMock(from address: String) -> ValueSignalProducer<CLLocation?>{
//    .init(value: .init(latitude: 0, longitude: 0))
//  }
  
  static func coordinateObservableMock(from address: String) -> Observable<CLLocation?> {
    Observable<CLLocation?>.just(.init(latitude: 0, longitude: 0))
  }

    static func coordinatesCompMock(from address: String, completion: ((CLLocation?, SimpleError?) -> Void)?) {
        completion?(.init(latitude: 0, longitude: 0), nil)
    }
}
