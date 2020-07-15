//
//  BundleHelper.swift
//  globee_kadaiTests
//
//  Created by motoki kawakami on 2020/07/15.
//  Copyright © 2020 mothule. All rights reserved.
//

import Foundation
import SwiftyJSON

private class Hoge {}
func loadJSON(_ fileName: String) -> JSON? {
    let bundle = Bundle(for: Hoge.self)
    let path = bundle.path(forResource: fileName, ofType: "json")
    assert(path != nil, "\(fileName).json was not found.")
    do {
        let jsonString = try String(contentsOfFile: path!)
        let json = JSON(parseJSON: jsonString)
        return json
    } catch {
        return nil
    }
}
