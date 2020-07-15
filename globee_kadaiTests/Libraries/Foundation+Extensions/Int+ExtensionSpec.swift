//
//  Int+ExtensionSpec.swift
//  
//
//  Created by motoki kawakami on 2020/07/09.
//  Copyright © 2020 mothule. All rights reserved.
//

import Quick
import Nimble

@testable import globee_kadai

class IntExtensionSpec: QuickSpec {
    override func spec() {
        describe("Int extension") {
            describe("toStringWithSeparator()") {
                it("should return separated string") {
                    expect(100.toStringWithSeparator()) == "100"
                    expect(1000.toStringWithSeparator()) == "1,000"
                    expect(100000.toStringWithSeparator()) == "100,000"
                    expect(1000000.toStringWithSeparator()) == "1,000,000"
                    expect((-100).toStringWithSeparator()) == "-100"
                    expect((-1000).toStringWithSeparator()) == "-1,000"
                }
            }
            
            describe("toMinuteAndSecond") {
                it("45 secs") {
                    let sub = (45).toMinuteAndSecond()
                    expect(sub.minute) == 0
                    expect(sub.second) == 45
                }
                
                it("60 mins") {
                    let sub = (60 * 60).toMinuteAndSecond()
                    expect(sub.minute) == 60
                    expect(sub.second) == 0
                }
                
                it("90 minutes") {
                    let sub = (90 * 60).toMinuteAndSecond()
                    expect(sub.minute) == 90
                    expect(sub.second) == 0
                }
                
                it("90 mins 30 secs") {
                    let sub = (90 * 60 + 30).toMinuteAndSecond()
                    expect(sub.minute) == 90
                    expect(sub.second) == 30
                }
            }
            
            describe("day hour minute second props") {
                it("") {
                    let subject = 2.day - 1.second
                    expect(subject) == 1.day + 23.hour + 59.minute + 59.second
                }
            }

            describe("times prop") {
                it("") {
                    var count = 0
                    10.times.forEach({ _ in count += 1 })
                    expect(count) == 10
                }
            }
        }
        
        describe("Int? extension") {
            describe("toStringOrNil") {
                it("") {
                    var subject: Int? = nil
                    expect(subject.toStringOrNil).to(beNil())
                    
                    subject = 1234
                    expect(subject.toStringOrNil).toNot(beNil())
                    expect(subject.toStringOrNil) == "1234"
                }
            }
        }

    }
}
