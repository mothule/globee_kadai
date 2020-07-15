//
//  Theme.swift
//  globee_kadai
//
//  Created by motoki kawakami on 2020/07/15.
//  Copyright © 2020 mothule. All rights reserved.
//

import Foundation
import UIKit

struct Theme {
    struct Colors {
        var accent: UIColor = UIColor(named: "accent")!
        var primary: UIColor = UIColor(named: "primary")!
        var secondary: UIColor = UIColor(named: "secondary")!
    }
    
    static var color: Colors = Colors()
}
