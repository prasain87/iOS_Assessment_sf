//
//  Utils.swift
//  SwiftUIIntergrationProjectTests
//
//  Created by Prateek Sujaina on 03/06/24.
//

import Foundation

class Utils {
    static func getData(filename: String, ext: String?) throws -> Data {
        let url = Bundle(for: Utils.self).url(forResource: filename, withExtension: ext)!
        return try Data(contentsOf: url)
    }
}
