//
//  NSObjectProtocol+ClassName.swift
//  
//
//  Created by motoki kawakami on 2020/07/09.
//  Copyright © 2020 mothule. All rights reserved.
//

import Foundation

extension NSObjectProtocol {
    static var className: String { String(describing: self) }
}
