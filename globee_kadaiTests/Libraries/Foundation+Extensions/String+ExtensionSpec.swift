//
//  String+ExtensionSpec.swift
//  
//
//  Created by motoki kawakami on 2020/07/09.
//  Copyright © 2020 mothule. All rights reserved.
//

import Quick
import Nimble
@testable import globee_kadai

class StringExtensionSpec: QuickSpec {
    override func spec() {
        describe("String + extension") {
            describe("isAny prop") {
                it("") {
                    expect("".isAny) == false
                    expect("a".isAny) == true
                }
            }
            
            describe("hasMultiByteString") {
                it("") {
                    expect("a".hasMultiByteString) == false
                    expect("あ".hasMultiByteString) == true
                    expect("".hasMultiByteString) == false
                    expect("1".hasMultiByteString) == false
                }
            }
            
            describe("toDouble prop") {
                it("") {
                    expect("1".toDouble) == 1.0
                    expect("1.2".toDouble) == 1.2
                    expect("1.2a".toDouble).to(beNil())
                }
            }
            
            describe("toURL prop") {
                it("Should return URL") {
                    expect("https://www.google.co.jp".toURL).notTo(beNil())
                }
                it("Should return nil") {
                    expect("".toURL).to(beNil())
                    
                    let string: String? = nil
                    expect(string?.toURL).to(beNil())
                }
            }

            describe("truncating method") {
                it("Should return itself if its lenght is less than specified length.") {
                    let input = "ABCD"
                    let ret = input.truncating(length: 5, trailing: "@")
                    
                    expect(ret) == "ABCD"
                }
                
                it("Should return itself if its lenght equals to specified length.") {
                    let input = "ABCDE"
                    let ret = input.truncating(length: 5, trailing: "@")
                    
                    expect(ret) == "ABCDE"
                }
                
                it("Should return trancated string with trailing appended if its lenght is over the specific length") {
                    let input = "ABCDEFG"
                    let ret = input.truncating(length: 5, trailing: "@")
                    
                    expect(ret) == "ABCDE@"
                }
            }
        }
        
        describe("A Optional String") {
            describe("orEmpty property") {
                it("return empty") {
                    let sub: String? = nil
                    expect(sub.orEmpty) == ""
                }
                
                it("return string") {
                    let sub: String? = "hoge"
                    expect(sub.orEmpty) == "hoge"
                }
            }
        }

        
    }
}
