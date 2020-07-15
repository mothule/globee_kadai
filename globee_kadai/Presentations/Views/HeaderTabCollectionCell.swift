//
//  HeaderTabCollectionCell.swift
//  globee_kadai
//
//  Created by motoki kawakami on 2020/07/15.
//  Copyright © 2020 mothule. All rights reserved.
//

import Foundation
import UIKit

class HeaderTabCollectionCell: UICollectionViewCell, Nibable {
    @IBOutlet private weak var label: UILabel!
    @IBOutlet private weak var underLine: UIView!
        
    func setup(label: String?, isActive: Bool) {
        self.label.text = label.orEmpty
        self.label.textColor = isActive ? Theme.color.accent : Theme.color.secondary

        self.underLine.layer.cornerRadius = 4
        self.underLine.isShown = isActive
        self.underLine.backgroundColor = Theme.color.accent
    }
}
