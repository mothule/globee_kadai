//
//  Book.swift
//  globee_kadai
//
//  Created by motoki kawakami on 2020/07/14.
//  Copyright © 2020 mothule. All rights reserved.
//

import Foundation
import SwiftyJSON

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
