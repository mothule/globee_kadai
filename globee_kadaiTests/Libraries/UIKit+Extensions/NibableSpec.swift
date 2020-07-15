//
//  NibableSpec.swift
//
//
//  Created by motoki kawakami on 2020/07/12.
//  Copyright © 2020 mothule. All rights reserved.
//

import Foundation
import Quick
import Nimble

@testable import globee_kadai

class NibableSpec: QuickSpec {
    override func spec() {
        describe("Nibable") {
            describe("nib prop") {
                it("") {
                    let nib = Hoge.nib
                    expect {
                        nib.instantiate(withOwner: self)
                    }.to(raiseException())
                }
            }
        }
    }
}

private class Hoge: NSObject, Nibable {}
