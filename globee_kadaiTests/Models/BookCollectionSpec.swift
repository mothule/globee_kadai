//
//  BookCollectionSpec.swift
//  globee_kadaiTests
//
//  Created by motoki kawakami on 2020/07/15.
//  Copyright © 2020 mothule. All rights reserved.
//

import Foundation
import Quick
import Nimble
import SwiftyJSON
@testable import globee_kadai

class BookCollectionSpec: QuickSpec {
    override func spec() {
        describe("BookCollection") {
            var target: BookCollection!
            
            describe("init(from:)") {
                var json: JSON { loadJSON("book_all")! }
                beforeEach {
                    target = BookCollection(from: json)
                }
                
                it("should sync top category names") {
                    expect(target.topCategorizedBookLineList).to(haveCount(5))
                    expect(target.topCategoryNames).to(haveCount(5))
                }
                
                it("") {
                    expect(target.topCategoryNames).to(equal([
                        "すべて",
                        "Unlimited",
                        "TOEIC",
                        "英検",
                        "英会話"
                    ]))
                }
            }
        }
    }
}

