//
//  NetworkMock.swift
//  SwiftUIIntergrationProjectTests
//
//  Created by Prateek Sujaina on 02/06/24.
//

import Foundation
import RxSwift

final class NetworkMock: NetworkService {
    private var responseQueue: [Data] = []
    
    func appendResponse(data: Data) {
        responseQueue.append(data)
    }
    
    func reset() {
        responseQueue.removeAll()
    }

    func data<T: Decodable>(url: URL) -> Observable<T?> {
        guard !responseQueue.isEmpty else {
            return .just(nil)
        }
        let data = responseQueue.removeFirst()
        let obj = try? JSONDecoder().decode(T.self, from: data)
        return .just(obj)
    }
}
