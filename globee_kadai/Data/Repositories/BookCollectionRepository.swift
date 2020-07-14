//
//  BookCollectionRepository.swift
//  globee_kadai
//
//  Created by motoki kawakami on 2020/07/14.
//  Copyright © 2020 mothule. All rights reserved.
//

import Foundation


enum TopCategorizedBookError: Error {
    case apiError(Error)
}

protocol BookCollectionRepository {
    func fetchAll() -> EzTask<BookCollection, TopCategorizedBookError>
}

class BookCollectionRepositoryImpl: BookCollectionRepository {
    private var cache: Cache<BookCollection> = .init(key: "top_categorized_book", expireTime: 10.minute)
    
    func fetchAll() -> EzTask<BookCollection, TopCategorizedBookError> {
        .init { (fulfill, reject) in
            let req = BookListGetRequest()
            APIClient.shared.send(request: req) { [weak self] result in
                switch result {
                case .success(let response):
                    if let self = self {
                        let bookCollection = BookCollection(from: response.value)
                        self.cache.value = bookCollection
                        fulfill(bookCollection)
                    }
                    
                case .failure(let error):
                    print(error)
                    reject(.apiError(error))
                }
            }
        }
    }
    
}
