//
//  CollectionExtensionSpec.swift
//  
//
//  Created by motoki kawakami on 2020/07/09.
//  Copyright © 2020 mothule. All rights reserved.
//

import Foundation

import Quick
import Nimble
@testable import globee_kadai

class CollectionExtensionSpec: QuickSpec {
    override func spec() {
        describe("Collection extension") {
            
            describe("isAny prop") {
                it("") {
                    expect(["a": 1].isAny) == true
                    expect([String:Int]().isAny) == false
                    expect([1].isAny) == true
                    expect([Int]().isAny) == false
                }
            }

            describe("safe subscript") {
                context("When index is out of range") {
                    it("Should return nil") {
                        let values = [1, 2, 3]
                        expect(values[safe: 3]).to(beNil())
                    }
                }
                context("When index is in range") {
                    it("Should return value") {
                        let values = [1, 2, 3]
                        expect(values[safe: 0]).notTo(beNil())
                        expect(values[safe: 2]).notTo(beNil())
                    }
                }
            }
        }
    }
}
