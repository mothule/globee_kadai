//
//  BookCollection.swift
//  globee_kadai
//
//  Created by motoki kawakami on 2020/07/14.
//  Copyright © 2020 mothule. All rights reserved.
//

import Foundation
import SwiftyJSON

class BookCollection {
    private(set) var topCategorizedBookLineList: [TopCategorizedBookLine] = []
    private(set) var topCategoryNames: [String] = []
    
    init() { }
    
    init(from json: JSON) {
        topCategorizedBookLineList = json["top_category_list"].arrayValue.map { TopCategorizedBookLine(from: $0) }
        topCategoryNames = topCategorizedBookLineList.map { $0.nameCategory }
    }
}
