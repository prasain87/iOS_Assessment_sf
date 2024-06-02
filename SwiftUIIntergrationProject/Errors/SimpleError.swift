//
//  SimpleError.swift
//  SwiftUIIntergrationProject
//
//  Created by Yuchen Nie on 5/22/24.
//

import Foundation

public enum SimpleError: Error, Equatable {
  case address(String?)
  case dataLoad(String)
  case dataParse(String?)
  case networkNoAvailable
}

extension SimpleError {
    var displayMsg: String {
        return switch self {
        case .address(let msg):
            msg ?? "Invalid address entered!"
        case .dataLoad(let msg):
            msg
        case .dataParse(let msg):
            msg ?? "Invalid response received!"
        case .networkNoAvailable:
            "Network unavailable or a network error occurred!"
        }
    }
}
