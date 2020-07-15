//
//  StringDateSpec.swift
//  
//
//  Created by motoki kawakami on 2020/07/13.
//  Copyright © 2020 mothule. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import globee_kadai

class StringDateExtensionSpec: QuickSpec {
    override func spec() {
        describe("String + extension") {
            describe("toDate fromFormat method") {
                context("when invalid format") {
                    it("should return nil") {
                        expect("asdf".toDate(format: "yyyy-MM-ddTHH:mm:ss.SSS")).to(beNil())
                    }
                }
                
                it("Should return valid Date if +09:00") {
                    let string: String = "2017-08-01T22:34:39.000+09:00"
                    let date: Date? = string.toDate(format: "yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSSZ")
                    expect(date).notTo(beNil())
                    if let date: Date = date {
                        expect(date.toString(format: "yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSSZZZZZ")) == string
                    }
                }

                it("Should return valid Date if +0900") {
                    let string: String = "2017-08-01T22:34:39.000+0900"
                    let date: Date? = string.toDate(format: "yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSSZ")
                    expect(date).notTo(beNil())
                    if let date: Date = date {
                        expect(date.toString(format: "yyyy'-'MM'-'dd'T'HH':'mm':'ss'.'SSSZ")) == string
                    }
                }
            }
        }
    }
}
