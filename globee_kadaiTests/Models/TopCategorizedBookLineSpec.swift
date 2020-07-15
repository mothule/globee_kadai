//
//  TopCategorizedBookLineSpec.swift
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

class TopCategorizedBookLineSpec: QuickSpec {
    override func spec() {
        describe("TopCategorizedBookLine") {
            var target: TopCategorizedBookLine!
            
            describe("init(from:)") {
                var json: JSON { loadJSON("book_all")!["top_category_list"].arrayValue.first! }
                beforeEach {
                    target = TopCategorizedBookLine(from: json)
                }
                it("") {
                    expect(target.idTopCategory) == "_top"
                    expect(target.nameCategory) == "すべて"
                    expect(target.subCategoryList).to(haveCount(10))
                }
                
            }
        }
    }
}

