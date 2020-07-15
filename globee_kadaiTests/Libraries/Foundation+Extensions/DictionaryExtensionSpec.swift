//
//  DictionaryExtensionSpec.swift
//
//
//  Created by motoki kawakami on 2020/07/12.
//  Copyright © 2020 mothule. All rights reserved.
//

import Foundation
import Quick
import Nimble

@testable import globee_kadai

class DictionaryExtensionSpec: QuickSpec {
    override func spec() {
        describe("Dictionary extension") {
            var target: [String: Int]!
            beforeEach {
                target = [
                    "A": 1,
                    "B": 2,
                    "C": 3
                ]
            }
            describe("hasKey(:)") {
                func subject(key: String) -> Bool { target.hasKey(key) }
                it("") {
                    expect(subject(key: "A")) == true
                    expect(subject(key: "asdf")) == false
                }
            }
            
            describe("containsKey(:)") {
                func subject(key: String) -> Bool { target.containsKey(key) }
                it("") {
                    expect(subject(key: "A")) == true
                    expect(subject(key: "asdf")) == false
                }
            }
            
            describe("exists(key:)") {
                func subject(key: String) -> Bool { target.exists(key: key) }
                it("") {
                    expect(subject(key: "A")) == true
                    expect(subject(key: "asdf")) == false
                }
            }
        }
    }
}

