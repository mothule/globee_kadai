//
//  BookDetailPresenterSpec.swift
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

class BookDetailPresenterSpec: QuickSpec {
    override func spec() {
        describe("BookDetailPresenter") {
            var target: BookDetailPresenterImpl!
            var viewer: BookDetailViewerMock!
            var repository: MyBookRepositoryMock!
            var book: Book!
            var error: NSError { .init(domain: "domain", code: -1, userInfo: nil) }
            
            
            beforeEach {
                let dict: [String: Any] = [
                    "author": "TEX加藤",
                    "create_at": "2017-01-06",
                    "has_contents": 1,
                    "has_purchased": false,
                    "id_book": "tokyu_kinhure_new",
                    "img_url": "https://d3grtcc7imzgqe.cloudfront.net/img/book_small/tokyu_kinhure_new.jpg",
                    "is_unlimited": 1,
                    "name_book": "TOEIC L&R TEST 出る単特急 金のフレーズ",
                    "publisher": "朝日新聞出版"
                ]
                let json = JSON(dict)
                book = Book(from: json)
                
                repository = MyBookRepositoryMock()
                viewer = BookDetailViewerMock()
                target = BookDetailPresenterImpl(repository: repository, viewer: viewer, book: book)
            }

            describe("fetchBook()") {

                context("When successful") {
                    it("") {
                        let record = MyBookRecord()
                        record.identifier = "identifier"
                        repository.myBookRecord = record
                        target.fetchBook()
                        expect(viewer.isHasBeenCalled("updateAddedMyBookButton(isAddedMyBook:)")) == true
                    }
                }
                context("When fetch error") {
                    it("") {
                        repository.error = .fetchError(error)
                        target.fetchBook()
                        expect(viewer.isNeverCalled("updateAddedMyBookButton(isAddedMyBook:)")) == true
                    }
                }
                context("When not found error") {
                    it("") {
                        repository.error = .fetchNotFoundError
                        target.fetchBook()
                        expect(viewer.isHasBeenCalled("updateAddedMyBookButton(isAddedMyBook:)")) == true
                    }
                }
            }
            
            describe("toogleMyBook()") {

                context("When have no added") {
                    beforeEach {
                        target.isAddedMyBook = false
                    }
                    context("When failure") {
                        beforeEach {
                            repository.error = .addError(error)
                        }
                        it("") {
                            target.toggleMyBook()
                            expect(viewer.isHasBeenCalled("showProgress()")) == true
                            expect(viewer.isHasBeenCalled("showAlert(message:)_MyBookへの追加に失敗しました。")) == true
                            expect(viewer.isHasBeenCalled("hideProgress()")) == true
                        }
                    }
                    context("When sucessfule") {
                        it("") {
                            target.toggleMyBook()
                            expect(viewer.isHasBeenCalled("showProgress()")) == true
                            expect(viewer.isHasBeenCalled("showAlert(message:)_MyBookへ追加しました。")) == true
                            expect(viewer.isHasBeenCalled("hideProgress()")) == true
                            expect(target.isAddedMyBook) == true
                        }
                    }
                }
                
                context("When have added") {
                    beforeEach {
                        target.isAddedMyBook = true
                    }
                    context("When failure") {
                        beforeEach {
                            repository.error = .removeError(error)
                        }
                        it("") {
                            target.toggleMyBook()
                            expect(viewer.isHasBeenCalled("showProgress()")) == true
                            expect(viewer.isHasBeenCalled("showAlert(message:)_MyBookからの削除に失敗しました。")) == true
                            expect(viewer.isHasBeenCalled("hideProgress()")) == true
                        }
                    }
                    context("When sucessfule") {
                        it("") {
                            target.toggleMyBook()
                            expect(viewer.isHasBeenCalled("showProgress()")) == true
                            expect(viewer.isHasBeenCalled("showAlert(message:)_MyBookから削除しました。")) == true
                            expect(viewer.isHasBeenCalled("hideProgress()")) == true
                            expect(target.isAddedMyBook) == false
                        }
                    }
                }
            }

            describe("authorAndPublisher()") {
                it("") {
                    expect(target.authorAndPublisher()).to(haveCount(2))
                }

                context("When have author") {
                    it("") {
                        let subject = target.authorAndPublisher()
                        expect(subject[0]) == "著者：\(book.author)"
                        expect(subject[1]) == "出版社：\(book.publisher)"
                    }
                }
                
                context("When have no author") {
                    beforeEach {
                        let json = JSON(parseJSON: "{\"author\": null, \"publisher\": \"ぶんぶん堂\"}")
                        book = Book(from: json)
                        target = BookDetailPresenterImpl(repository: repository, viewer: viewer, book: book)
                    }
                    
                    it("") {
                        let subject = target.authorAndPublisher()
                        expect(subject[0]) == "出版社：ぶんぶん堂"
                        expect(subject[1]) == ""
                    }
                    
                }
            }
        }
    }
}

private class MyBookRepositoryMock: MyBookRepository, MockVerifyable {
    var verifies: [String: Int] = [:]
    var error: MyBookError? = nil
    var myBookRecord: MyBookRecord? = nil
    
    func add(with book: Book) -> EzTask<Void, MyBookError> {
        if let error = error {
            return .init(reject: error)
        }
        increment(with: #function)
        return .init(fulfill: ())
    }
    
    func remove(of book: Book) -> EzTask<Void, MyBookError> {
        if let error = error {
            return .init(reject: error)
        }
        increment(with: #function)
        return .init(fulfill: ())
    }
    
    func fetch(with book: Book) -> EzTask<MyBookRecord, MyBookError> {
        if let error = error {
            return .init(reject: error)
        }
        increment(with: #function)
        if let ret = myBookRecord {
            return .init(fulfill: ret)
        }
        fatalError()
    }
    
    
}

private class BookDetailViewerMock: UIViewControllerMock, BookDetailViewer {
    func updateAddedMyBookButton(isAddedMyBook: Bool) {
        increment(with: #function)
    }
    
    func showProgress() {
        increment(with: #function)
    }
    
    func hideProgress() {
        increment(with: #function)
    }
    
    func showAlert(message: String) {
        increment(with: #function)
        increment(with: "\(#function)_\(message)")
    }
}
