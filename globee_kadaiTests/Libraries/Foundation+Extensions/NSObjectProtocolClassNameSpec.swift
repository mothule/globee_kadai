//
//  NSObjectProtocolClassNameSpec.swift
//  
//
//  Created by motoki kawakami on 2020/07/11.
//  Copyright © 2020 mothule. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import globee_kadai

class NSObjectProtocolClassNameSpec: QuickSpec {
    override func spec() {
        describe("NSObjectProtocol+ClassName") {
            it("") {
                expect(NSString.className) == "NSString"
            }            
        }
    }
}

