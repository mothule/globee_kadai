//
//  UIViewExtensionSpec.swift
//  
//
//  Created by motoki kawakami on 2020/07/11.
//  Copyright © 2020 mothule. All rights reserved.
//

import Foundation
import Quick
import Nimble

@testable import globee_kadai

class UIViewExtensionSpec: QuickSpec {
    override func spec() {
        describe("UIView Extension") {
            var target: UIView!
            beforeEach {
                target = UIView(frame: .init(x: 0, y: 0, width: 200, height: 200))
            }
            describe("isShown") {
                it("") {
                    expect(target.isShown) == !target.isHidden
                }
                it("") {
                    target.isHidden = true
                    expect(target.isShown) == !target.isHidden
                }
                it("") {
                    target.isShown = false
                    expect(target.isShown) == !target.isHidden
                }
            }
        }
    }
}

