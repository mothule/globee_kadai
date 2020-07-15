//
//  ProgressHUD.swift
//  globee_kadai
//
//  Created by motoki kawakami on 2020/07/15.
//  Copyright © 2020 mothule. All rights reserved.
//

import Foundation
import PKHUD

struct ProgressHUD {
    static func show() {
        HUD.dimsBackground = true
        let view = UIView(frame: .init(x: 0, y: 0, width: 75, height: 75))
        view.backgroundColor = .darkGray
        let indicator = UIActivityIndicatorView(style: .whiteLarge)
        indicator.center = view.center
        indicator.color = .white
        indicator.startAnimating()
        view.addSubview(indicator)
        HUD.show(.customView(view: view))
    }
    
    static func hide() {
        HUD.hide()
    }
}
