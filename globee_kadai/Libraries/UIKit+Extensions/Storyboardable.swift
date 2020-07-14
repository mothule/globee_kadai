//
//  Storyboardable.swift
//  
//
//  Created by motoki kawakami on 2020/07/09.
//  Copyright © 2020 mothule. All rights reserved.
//

import Foundation
import UIKit

protocol Storyboardable: NSObjectProtocol {
    static var storyboardName: String { get }
}
extension Storyboardable {
    static var storyboardName: String { className }
}
extension Storyboardable where Self: UIViewController {
    static func instance(bundle: Bundle? = nil) -> Self {
        let vc: Self = UIStoryboard.instantiate(bundle: bundle)
        return vc
    }
}

extension UIStoryboard {
    static func instantiate<T: Storyboardable>(bundle: Bundle? = nil) -> T {
        let storyboard = UIStoryboard(name: T.storyboardName, bundle: bundle)
        if let vc = storyboard.instantiateInitialViewController() as? T {
            return vc
        }        
 
        return storyboard.instantiateViewController(withIdentifier: T.className) as! T
    }
}
