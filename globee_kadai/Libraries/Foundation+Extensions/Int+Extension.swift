//
//  Int+Extensions.swift
//  
//
//  Created by motoki kawakami on 2020/07/09.
//  Copyright © 2020 mothule. All rights reserved.
//

import Foundation

extension Int {
    func toMinuteAndSecond() -> (minute: Int, second: Int) {
        let oneMinute = 60
        let mins: Int = self / oneMinute
        let secs: Int = self - mins * oneMinute
        return (mins, secs)
    }
    
    var second: TimeInterval { TimeInterval(self) }
    var minute: TimeInterval { TimeInterval(self * 60) }
    var hour: TimeInterval { TimeInterval(self * 60 * 60) }
    var day: TimeInterval { TimeInterval(self * 60 * 60 * 24) }
}

extension Int {
    /// like active-support of ruby
    /// 5.times.forEach { print($0) }
    var times: CountableRange<Int> { (0..<self) }
}

extension Int {
    func toStringWithSeparator() -> String? {
        NSNumber(integerLiteral: self).toStringWithSeparator()
    }
}

extension Optional where Wrapped == Int {
    var toStringOrNil: String? {
        guard let value = self else { return nil }
        return String(value)
    }
}
