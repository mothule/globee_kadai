//
//  DateStringSpec.swift
//
//
//  Created by motoki kawakami on 2020/07/09.
//  Copyright © 2020 mothule. All rights reserved.
//

import Quick
import Nimble

@testable import globee_kadai

class DateStringSpec: QuickSpec {
    override func spec() {
        describe("Date + string") {
            describe("toString method") {
                it("should return date format string") {
                    var components = DateComponents()
                    components.year = 1998
                    components.month = 3
                    components.day = 11
                    let date = Calendar.current.date(from: components)!
                    expect(date.toString(format: "yyyy/MM/dd")) == "1998/03/11"
                    
                }
                
                context("when invalid date format") {
                    it("return not date string") {
                        var components = DateComponents()
                        components.year = 1998
                        components.month = 3
                        components.day = 11
                        let date = Calendar.current.date(from: components)!
                        expect(date.toString(format: "Ω≈ç√˜µ")) == "Ω≈ç√˜µ"
                    }
                }
                
                context("with default parameter") {
                    context("when month & date are represented by 1 digit") {
                        it("shoud return correct date format string") {
                            var components = DateComponents()
                            components.year = 1998
                            components.month = 1
                            components.day = 1
                            let date = Calendar.current.date(from: components)!
                            
                            expect(date.toString()) == "1998年1月1日"
                        }
                    }
                    
                    context("when month & date are represented by 2 digits") {
                        it("shoud return correct date format string") {
                            var components = DateComponents()
                            components.year = 1998
                            components.month = 12
                            components.day = 31
                            let date = Calendar.current.date(from: components)!
                            
                            expect(date.toString()) == "1998年12月31日"
                        }
                    }
                }
            }
        }
    }
}
