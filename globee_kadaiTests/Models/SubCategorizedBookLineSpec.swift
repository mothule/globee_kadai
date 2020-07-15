//
//  SubCategorizedBookLineSpec.swift
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

class SubCategorizedBookLineSpec: QuickSpec {
    override func spec() {
        describe("SubCategorizedBookLine") {
            var target: SubCategorizedBookLine!
            
            describe("init(from:)") {
                var json: JSON { loadJSON("book_all")!["top_category_list"].arrayValue.first!["sub_category_list"].arrayValue.first! }
                beforeEach {
                    target = SubCategorizedBookLine(from: json)
                }
                it("") {
                    expect(target.idCategory) == "_ranking"
                    expect(target.isRanking) == true
                    expect(target.nameCategory) == "人気ランキング"
                    expect(target.needLoadMore) == true
                    expect(target.bookList).to(haveCount(10))
                }
            }
        }
    }
}

