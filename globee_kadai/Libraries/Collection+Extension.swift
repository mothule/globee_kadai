//
//  Collection+Extension.swift
//
//
//  Created by motoki kawakami on 2020/07/02.
//  Copyright © 2020 mothule. All rights reserved.
//

import Foundation

extension Collection {
    var isAny: Bool { !isEmpty }
}

extension Collection {
    subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
