//
//  BookSpec.swift
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

class BookSpec: QuickSpec {
    override func spec() {
        describe("Book") {
            var target: Book!
            
            describe("init(from:)") {
                var json: JSON {
                    JSON(parseJSON: """
                    {
                        "author": "TEX加藤",
                        "create_at": "2017-01-06",
                        "has_contents": 1,
                        "has_purchased": false,
                        "id_book": "tokyu_kinhure_new",
                        "img_url": "https://d3grtcc7imzgqe.cloudfront.net/img/book_small/tokyu_kinhure_new.jpg",
                        "is_unlimited": 1,
                        "name_book": "TOEIC L&R TEST 出る単特急 金のフレーズ",
                        "publisher": "朝日新聞出版"
                    }
                    """)
                }
                
                it("can parse from JSON") {
                    target = Book(from: json)
                    expect(target.author) == "TEX加藤"
                    expect(target.nameBook) == "TOEIC L&R TEST 出る単特急 金のフレーズ"
                    expect(target.createdAt) == "2017-01-06"
                    expect(target.hasContents) == true
                    expect(target.hasPurchased) == false
                    expect(target.idBook) == "tokyu_kinhure_new"
                    expect(target.imageUrl) == "https://d3grtcc7imzgqe.cloudfront.net/img/book_small/tokyu_kinhure_new.jpg"
                    expect(target.isUnlimited) == true
                    expect(target.publisher) == "朝日新聞出版"
                }
            }
        }
    }
}


