//
//  UIViewControllerMock.swift
//
//
//  Created by motoki kawakami on 2020/07/15.
//  Copyright © 2020 mothule. All rights reserved.
//

import Foundation
import UIKit

class UIViewControllerMock: UIViewController, MockVerifyable {
    // MARK: - MockVerifyable
    typealias KeyType = String
    var verifies: [KeyType: Int] = [:]
}
