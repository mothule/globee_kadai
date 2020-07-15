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
            self.inBackground {
                do {
                    let entity = MyBookRecord()
                    entity.identifier = book.nameBook
                    let realm = try Realm()
                    try realm.write {
                        realm.add(entity)
                    }
                    // 一瞬だけUIが出るのはUX上よろしくないため
                    Thread.sleep(forTimeInterval: 0.3)
                    self.inMain {
                        fulfill(())
                    }
                } catch let error as NSError {
                    self.inMain {
                        reject(.addError(error))
                    }
                }
            }
        }
    }
    
    func remove(of book: Book) -> EzTask<Void, MyBookError> {
        .init { (fulfill, reject) in
            self.inBackground {
                do {
                    let realm = try Realm()
                    let result = realm.objects(MyBookRecord.self).filter("identifier == '\(book.nameBook)'")
                    try realm.write {
                        realm.delete(result)
                    }
                    Thread.sleep(forTimeInterval: 0.3)
                    self.inMain {
                        fulfill(())
                    }
                } catch let error as NSError {
                    self.inMain {
                        reject(.removeError(error))
                    }
                }
            }
        }
    }
    
    func fetch(with book: Book) -> EzTask<MyBookRecord, MyBookError> {
        .init { (fulfill, reject) in
            self.inBackground {
                do {
                    let realm = try Realm()
                    let results = realm.objects(MyBookRecord.self).filter("identifier == '\(book.nameBook)'")
                    if let result = results.first {
                        self.inMain { fulfill(result) }
                    } else {
                        self.inMain { reject(.fetchNotFoundError) }
                    }
                } catch let error as NSError {
                    self.inMain {
                        reject(.removeError(error))
                    }
                }
            }
        }
    }
    
    private func inBackground(process: @escaping (() -> Void)) {
        DispatchQueue.global().async {
            autoreleasepool {
                process()
            }
        }
    }
    
    private func inMain(process: @escaping (() -> Void)) {
        DispatchQueue.main.async {
            process()
        }
    }
}
