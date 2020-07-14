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
