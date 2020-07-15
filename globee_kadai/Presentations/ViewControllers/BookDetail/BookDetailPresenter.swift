//
//  BookDetailPresenter.swift
//  globee_kadai
//
//  Created by motoki kawakami on 2020/07/15.
//  Copyright © 2020 mothule. All rights reserved.
//

import Foundation

protocol BookDetailPresenter {
    var book: Book { get }
    var isAddedMyBook: Bool { get }
    
    func fetchBook()
    func toggleMyBook()
    func authorAndPublisher() -> [String]
}

class BookDetailPresenterImpl: BookDetailPresenter {
    // UTが書きやすいようscopeをprivateではなくinternalにしてる.
    // プロダクト側ではprotocolを使うので実害は少ない
    var viewer: BookDetailViewer!
    var repository: MyBookRepository!
    var book: Book
    var isAddedMyBook: Bool = false {
        didSet {
            viewer.updateAddedMyBookButton(isAddedMyBook: isAddedMyBook)
        }
    }
    
    init(repository: MyBookRepository, viewer: BookDetailViewer, book: Book) {
        self.repository = repository
        self.viewer = viewer
        self.book = book
    }
    
    func fetchBook() {
        repository.fetch(with: book).onSuccess({ [weak self] _ in
            self?.isAddedMyBook = true
        }).onFailure({ [weak self] error in
            if case .fetchNotFoundError = error {
                self?.isAddedMyBook = false
            }
        })
    }
    
    func toggleMyBook() {
        viewer.showProgress()
        
        if isAddedMyBook {
            repository.remove(of: book).onSuccess({ [weak self] _ in
                guard let self = self else { return }
                self.viewer.showAlert(message: "MyBookから削除しました。")
                self.isAddedMyBook = false
                self.viewer.hideProgress()
            }).onFailure({ [weak self] error in
                guard let self = self else { return }
                self.viewer.showAlert(message: "MyBookからの削除に失敗しました。")
                self.viewer.hideProgress()
            })
        } else {
            repository.add(with: book).onSuccess({ [weak self] _ in
                guard let self = self else { return }
                self.viewer.showAlert(message: "MyBookへ追加しました。")
                self.isAddedMyBook = true
                self.viewer.hideProgress()
            }).onFailure({ [weak self] error in
                guard let self = self else { return }
                self.viewer.showAlert(message: "MyBookへの追加に失敗しました。")
                self.viewer.hideProgress()
            })
        }
    }
    
    func authorAndPublisher() -> [String] {
        [
            book.author.isAny ? "著者：" + book.author : "出版社：" + book.publisher,
            book.author.isAny ? "出版社：" + book.publisher : ""
        ]
    }

}
