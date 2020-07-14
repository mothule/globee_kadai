//
//  MyBookRepository.swift
//  globee_kadai
//
//  Created by motoki kawakami on 2020/07/15.
//  Copyright © 2020 mothule. All rights reserved.
//

import Foundation
import RealmSwift

enum MyBookError: Error {
    case addError(Error)
    case removeError(Error)
    case fetchError(Error)
    case fetchNotFoundError
}

protocol MyBookRepository {
    func add(with book: Book) -> EzTask<Void, MyBookError>
    func remove(of book: Book) -> EzTask<Void, MyBookError>
    func fetch(with book: Book) -> EzTask<MyBookRecord, MyBookError>
}

class MyBookRepositoryImpl: MyBookRepository {
    func add(with book: Book) -> EzTask<Void, MyBookError> {
        .init { (fulfill, reject) in
            do {
                let entity = MyBookRecord()
                entity.identifier = book.nameBook
                let realm = try Realm()
                try realm.write {
                    realm.add(entity)
                }
                fulfill(())
            } catch let error as NSError {
                reject(.addError(error))
            }
        }
    }
    
    func remove(of book: Book) -> EzTask<Void, MyBookError> {
        .init { (fulfill, reject) in
            do {
                let realm = try Realm()
                let result = realm.objects(MyBookRecord.self).filter("identifier == '\(book.nameBook)'")
                try realm.write {
                    realm.delete(result)
                }
                fulfill(())
            } catch let error as NSError {
                reject(.removeError(error))
            }
        }
    }
    
    func fetch(with book: Book) -> EzTask<MyBookRecord, MyBookError> {
        .init { (fulfill, reject) in
            do {
                let realm = try Realm()
                let results = realm.objects(MyBookRecord.self).filter("identifier == '\(book.nameBook)'")
                if let result = results.first {
                    fulfill(result)
                } else {
                    reject(.fetchNotFoundError)
                }
            } catch let error as NSError {
                reject(.removeError(error))
            }
        }
    }
}
