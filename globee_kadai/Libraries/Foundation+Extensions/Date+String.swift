//
//  Date+String.swift
//
//
//  Created by motoki kawakami on 2020/07/01.
//  Copyright © 2020 mothule. All rights reserved.
//

import Foundation

extension Date {
    func toString(format: String = "yyyy年M月d日",
                  locale: Locale = .enUsPosix,
                  timeZone: TimeZone = .current) -> String {
        let fmt = DateFormatter()
        fmt.dateFormat = format
        fmt.locale = locale
        fmt.timeZone = timeZone
        return fmt.string(from: self)
    }
}
