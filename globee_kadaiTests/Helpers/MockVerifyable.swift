//
//  MockVerifyable.swift
//
//
//  Created by motoki kawakami on 2020/07/15.
//  Copyright © 2020 mothule. All rights reserved.
//

import Foundation
//import SwiftyJSON
import XCTest
//@testable import globee_kadai


protocol MockVerifyable: class {
    associatedtype KeyType: Hashable
    var verifies: [KeyType: Int] { get set }
}
extension MockVerifyable {
    func increment(with key: KeyType) {
        if verifies[key] != nil {
            verifies[key] = verifies[key]! + 1
        } else {
            verifies[key] = 1
        }
    }
    func countCalled(of key: KeyType) -> Int {
        guard let count = verifies[key] else {
            return 0
        }
        return count
    }
    
    func isNeverCalled(_ key: KeyType) -> Bool {
        return countCalled(of: key) == 0
    }
    func isHasBeenCalled(_ key: KeyType) -> Bool {
        let ret = !isNeverCalled(key)
        if ret == false {
            let keys = verifies.keys.map { $0 as! String }.joined(separator: ", ")
            print("🤑: Registered methods \(keys)")
        }
        return ret
    }
    func clearCount(of key: KeyType) {
        if verifies[key] != nil {
            verifies[key] = 0
        }
    }
    func clearAllCount() {
        verifies.removeAll()
    }
}
