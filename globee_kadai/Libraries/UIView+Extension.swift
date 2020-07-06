//
//  UIView+Extension.swift
//  globee_kadai
//
//  Created by motoki kawakami on 2020/07/03.
//  Copyright © 2020 mothule. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    var isShown: Bool {
        set {
            isHidden = !newValue
        }
        get {
            !isHidden
        }
    }
}
