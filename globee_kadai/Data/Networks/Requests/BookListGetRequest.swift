//
//  BookListGetRequest.swift
//  globee_kadai
//
//  Created by motoki kawakami on 2020/07/03.
//  Copyright © 2020 mothule. All rights reserved.
//

import Foundation
import SwiftyJSON

struct BookListGetRequest: APIRequestable {
    var path: String { "/mock/book/all" }
}

/**
 ## JSON format
 ```JSON
 {
    "id_top_category": "_top",
    "name_category": "すべて",
    "sub_category_list": []
 }
 ```
 */
struct BookListGetResponse {
    let idTopCategory: String
    let nameCategory: String
    let subCategoryList: [SubCategory]
    
    static func parse(from json: JSON) -> [Self] {
        json["top_category_list"].arrayValue.map { Self.init(from: $0) }
    }
    
    init(from json: JSON) {
        idTopCategory = json["id_top_category"].stringValue
        nameCategory = json["name_category"].stringValue
        subCategoryList = json["sub_category_list"].arrayValue.map { SubCategory(from: $0) }
    }
}

/**
 ## JSON format
 ```JSON
 {
     "book_list": [],
     "id_category": "_ranking",
     "is_ranking": true,
     "name_category": "人気ランキング",
     "need_load_more": true
 }
 ```
 */
struct SubCategory {
    let bookList: [Book]
    let idCategory: String
    let isRanking: Bool
    let nameCategory: String
    let needLoadMore: Bool
    
    init(from json: JSON) {
        bookList = json["book_list"].arrayValue.map { Book(from: $0) }
        idCategory = json["id_category"].stringValue
        isRanking = json["is_ranking"].boolValue
        nameCategory = json["name_category"].stringValue
        needLoadMore = json["need_load_more"].boolValue
    }
}

/**
 ## JSON format
 ```JSON
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
 ```
 */
struct Book {
    let author: String
    let createdAt: String
    let hasContents: Bool
    let hasPurchased: Bool
    let idBook: String
    let imageUrl: String
    let isUnlimited: Bool
    let nameBook: String
    let publisher: String

    init(from json: JSON) {
        author = json["author"].stringValue
        createdAt = json["created_at"].stringValue
        hasContents = json["has_contents"].intValue > 0
        hasPurchased = json["has_purchased"].boolValue
        idBook = json["id_book"].stringValue
        imageUrl = json["img_url"].stringValue
        isUnlimited = json["is_unlimited"].intValue > 0
        nameBook = json["name_book"].stringValue
        publisher = json["publisher"].stringValue
    }
}
