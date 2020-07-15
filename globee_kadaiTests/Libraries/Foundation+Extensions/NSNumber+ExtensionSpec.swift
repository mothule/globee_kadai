//
//  NSNumber+ExtensionSpec.swift
//  
//
//  Created by motoki kawakami on 2020/07/09.
//  Copyright © 2020 mothule. All rights reserved.
//

import Quick
import Nimble
@testable import globee_kadai

class NSNumberExtensionSpec: QuickSpec {
    override func spec() {
        describe("NSNumber") {
            describe("toStringWithSeparator()") {
                it("should return separated string") {
                    expect(NSNumber(value: 100).toStringWithSeparator()) == "100"
                    expect(NSNumber(value: 1000).toStringWithSeparator()) == "1,000"
                    expect(NSNumber(value: 100000).toStringWithSeparator()) == "100,000"
                    expect(NSNumber(value: 1000000).toStringWithSeparator()) == "1,000,000"
                    expect(NSNumber(value: -100).toStringWithSeparator()) == "-100"
                    expect(NSNumber(value: -1000).toStringWithSeparator()) == "-1,000"
                    expect(NSNumber(value: 1000.5).toStringWithSeparator()) == "1,000.5"
                }
            }
        }

    }
}
