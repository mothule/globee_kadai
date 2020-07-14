//
//  TopCategorizedBookLine.swift
//  globee_kadai
//
//  Created by motoki kawakami on 2020/07/14.
//  Copyright © 2020 mothule. All rights reserved.
//

import Foundation
import SwiftyJSON

/// トップカテゴリのひとかたまり
struct TopCategorizedBookLine {
    let idTopCategory: String
    let nameCategory: String
    let subCategoryList: [SubCategorizedBookLine]

    init(from json: JSON) {
        idTopCategory = json["id_top_category"].stringValue
        nameCategory = json["name_category"].stringValue
        subCategoryList = json["sub_category_list"].arrayValue.map { SubCategorizedBookLine(from: $0) }
    }
}
