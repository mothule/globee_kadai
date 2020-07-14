//
//  UICollectionView+Cell.swift
//  
//
//  Created by motoki kawakami on 2020/07/09.
//  Copyright © 2020 mothule. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionView {
    func dequeueReusableCell<T: UICollectionViewCell>(_ cellType: T.Type, for indexPath: IndexPath) -> T {
        dequeueReusableCell(withReuseIdentifier: T.className, for: indexPath) as! T
    }
    func dequeueReusableSupplementaryView<T: UICollectionReusableView>(_ viewType: T.Type, ofKind kind: String, for indexPath: IndexPath) -> T {
        dequeueReusableSupplementaryView(ofKind: kind,
                                         withReuseIdentifier: T.className,
                                         for: indexPath) as! T
    }
    
    func register<T: UICollectionReusableView>(_ viewType: T.Type) where T: Nibable {
        register(T.nib, forCellWithReuseIdentifier: T.className)
    }
    func register<T: UICollectionReusableView>(_ viewType: T.Type) {
        register(T.self, forCellWithReuseIdentifier: T.className)
    }
    func registerSupplementaryView<T: UICollectionReusableView>(_ viewType: T.Type, kindOf kind: String) where T: Nibable {
        register(T.nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: T.className)
    }
}
