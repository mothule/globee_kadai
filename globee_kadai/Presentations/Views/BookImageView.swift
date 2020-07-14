//
//  BookImageView.swift
//  globee_kadai
//
//  Created by motoki kawakami on 2020/07/14.
//  Copyright © 2020 mothule. All rights reserved.
//

import UIKit

class BookImageView: UIImageView {
    func setup(with url: String) {
        sd_setImageWithFadeIn(url: url)
        caskShadow()
    }
    
    private func caskShadow() {
        layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.7
        layer.shadowRadius = 1
        layer.masksToBounds = false
    }
}
