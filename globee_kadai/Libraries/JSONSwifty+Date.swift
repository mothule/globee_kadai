//
//  JSONSwifty+Date.swift
//  globee_kadai
//
//  Created by motoki kawakami on 2020/07/03.
//  Copyright © 2020 mothule. All rights reserved.
//

import Foundation
import SwiftyJSON

extension JSON {
    func date(timeZone: TimeZone = .tokyo) -> Date? {
        self.stringValue.toDate(format: "yyyy'-'MM'-'dd'", timeZone: timeZone)
    }
    
    func dateValue(timeZone: TimeZone = .tokyo, default: Date) -> Date {
        self.date(timeZone: timeZone) ?? `default`
    }
}
