//
//  Nibable.swift
//  
//
//  Created by motoki kawakami on 2020/07/09.
//  Copyright © 2020 mothule. All rights reserved.
//

import Foundation
import UIKit

protocol Nibable: NSObjectProtocol {
    static var nibName: String { get }
    static var nib: UINib { get }
}
extension Nibable {
    static var nibName: String { className }
    static var nib: UINib { UINib(nibName: nibName, bundle: nil) }
}
