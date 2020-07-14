//
//  SubCategorizedBookLine.swift
//  globee_kadai
//
//  Created by motoki kawakami on 2020/07/14.
//  Copyright © 2020 mothule. All rights reserved.
//

import Foundation
import SwiftyJSON

struct SubCategorizedBookLine {
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
