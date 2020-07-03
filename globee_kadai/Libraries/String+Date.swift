//
//  String+Date.swift
//
//
//  Created by motoki kawakami on 2020/07/03.
//  Copyright © 2020 mothule. All rights reserved.
//

import Foundation

extension String {
    func toDate(format: String, timeZone: TimeZone = .tokyo) -> Date? {
        let fmt = DateFormatter()
        fmt.dateFormat = format
        fmt.locale = Locale(identifier: "en_US_POSIX")
        fmt.timeZone = .current
        return fmt.date(from: self)
    }
}
