//
//  Stubber.swift
//  eigamiTests
//
//  Created by aarif on 2018/03/10.
//

import Foundation

class Stubber {
    class func jsonDataFromFile(_ fileName: String) -> Data {
        guard let path = Bundle.main.path(forResource: fileName, ofType: "json") else {
            fatalError("Invalid path for file")
        }
        guard let data = try? Data(contentsOf: URL(fileURLWithPath: path)) else {
            fatalError("Invalid json file")
        }
        return data
    }
}
