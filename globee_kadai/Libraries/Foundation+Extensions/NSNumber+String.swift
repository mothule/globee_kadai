//
//  NSNumber+String.swift
//  
//
//  Created by motoki kawakami on 2020/07/09.
//  Copyright © 2020 mothule. All rights reserved.
//

import Foundation

extension NSNumber {
    func toStringWithSeparator() -> String? {
        let f = NumberFormatter()
        f.numberStyle = .decimal
        f.groupingSeparator = ","
        f.groupingSize = 3
        return f.string(from: self)
    }
}
