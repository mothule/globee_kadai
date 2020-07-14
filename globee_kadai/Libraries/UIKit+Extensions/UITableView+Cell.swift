//
//  UITableView+Cell.swift
//  
//
//  Created by motoki kawakami on 2020/07/09.
//  Copyright © 2020 mothule. All rights reserved.
//

import Foundation
import UIKit

extension UITableView {
    func dequeueReusableCell<T: UITableViewCell>(_ cellType: T.Type, for indexPath: IndexPath) -> T {
        dequeueReusableCell(withIdentifier: T.className, for: indexPath) as! T
    }
    
    func register<T: UITableViewCell>(_ viewType: T.Type) where T: Nibable {
        register(T.nib, forCellReuseIdentifier: T.className)
    }
    func register<T: UITableViewCell>(_ viewType: T.Type) {
        register(T.self, forCellReuseIdentifier: T.className)
    }
}
