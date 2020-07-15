//
//  Dictionary+Extension.swift
//
//
//  Created by motoki kawakami on 2020/07/12.
//  Copyright © 2020 mothule. All rights reserved.
//

import Foundation

extension Dictionary {
    /// キーの有無確認
    func hasKey(_ key: Key) -> Bool { self[key] != nil }
    
    /// same as hasKey(_:) method
    func containsKey(_ key: Key) -> Bool { hasKey(key) }
    
    /// same as hasKey(_:) method
    func exists(key: Key) -> Bool { hasKey(key) }
}
