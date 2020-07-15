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
    struct Fonts {
        var jaRegularName = "HiraKakuProN-W3"   // 日本語 通常フォント名
        var jaBoldName = "HiraKakuProN-W6"      // 日本語 太字フォント名
        var regularName = "AvenirNext-Regular"  // 英字/数字/記号 通常フォント名
        var boldName = "AvenirNext-Bold"        // 英字/数字/記号 太字フォント名
    }
    
    static var color: Colors = Colors()
    // static var fonts: Fonts = Fonts() フォントが必要になれば
}
