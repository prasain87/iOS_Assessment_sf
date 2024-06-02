//
//  NetworkService.swift
//  SwiftUIIntergrationProject
//
//  Created by Prateek Sujaina on 02/06/24.
//

import Foundation
import RxSwift

protocol NetworkService {
    func data<T: Decodable>(url: URL) -> Observable<T?>
}

final class NetworkServiceDefault: NetworkService {
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
