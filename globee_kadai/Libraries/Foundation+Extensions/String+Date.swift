//
//  String+Date.swift
//
//
//  Created by motoki kawakami on 2020/07/03.
//  Copyright © 2020 mothule. All rights reserved.
//

import Foundation

extension String {
    func toDate(format: String, timeZone: TimeZone = .current) -> Date? {
        let fmt = DateFormatter()
        fmt.locale = .enUsPosix
        fmt.timeZone = timeZone
        fmt.dateFormat = format
        return fmt.date(from: self)
    }
}
