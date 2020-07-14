//
//  BookDetailViewController.swift
//  globee_kadai
//
//  Created by motoki kawakami on 2020/07/03.
//  Copyright © 2020 mothule. All rights reserved.
//

import UIKit

class BookDetailViewController: UIViewController, Storyboardable {
    @IBOutlet private weak var bookImageView: BookImageView!
    @IBOutlet private weak var bookTitleLabel: UILabel!
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var publisherLabel: UILabel!
    @IBOutlet private weak var addMyBookButton: UIButton!
    @IBOutlet private weak var purchaseButton: UIButton!
    
    private let repository: MyBookRepository = MyBookRepositoryImpl()
    
    private var book: Book!
    private var isAddedMyBook: Bool = false {
        didSet {
            updateAddedMyBookButton(isAddedMyBook: isAddedMyBook)
        }
    }
    
    func setup(book: Book) {
        self.book = book
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bookImageView.setup(with: book.imageUrl)
        
        bookTitleLabel.attributedText = book.nameBook.decorate(by: [.lineHeight(bookTitleLabel.font.pointSize * 1.4)])
        authorLabel.text = "著者：" + book.author
        publisherLabel.text = "出版社：" + book.publisher
        isAddedMyBook = false
//        updateAddedMyBookButton(isAddedMyBook: false)

        purchaseButton.layer.cornerRadius = 4.0
        purchaseButton.backgroundColor = UIColor.systemPink
        purchaseButton.setTitleColor(.white, for: .normal)
        purchaseButton.setTitle("購入", for: .normal)

        navigationController?.navigationBar.topItem!.title = "書籍紹介"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "データ削除", style: .plain, target: self, action: #selector(onTouchedDeleteDataOnNavBar(_:)))
        
        repository.fetch(with: book).onSuccess({ _ in
            self.isAddedMyBook = true
        }).onFailure({ error in
            if case .fetchNotFoundError = error {
                self.isAddedMyBook = false
            }
        })
    }
    
    @IBAction func onTouchedAddMyBooksButton(_ sender: Any) {
        // プログレス表示
        print(#function)
        
        if isAddedMyBook {
            repository.remove(of: book).onSuccess({ [weak self] _ in
                self?.showAlert(message: "MyBookから削除しました。")
                self?.isAddedMyBook = false
            }).onFailure({ error in
                self.showAlert(message: "MyBookからの削除に失敗しました。")
            })
        } else {
            repository.add(with: book).onSuccess({ [weak self] _ in
                self?.showAlert(message: "MyBookへ追加しました。")
                self?.isAddedMyBook = true
            }).onFailure({ error in
                self.showAlert(message: "MyBookへの追加に失敗しました。")
            })
        }
    }
    
    @objc private func onTouchedDeleteDataOnNavBar(_ sender: AnyObject) {
        let actionSheet = UIAlertController(title: "編集", message: "", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "学習データを削除", style: .destructive, handler: { action in
            print("学習データ削除処理")
        }))
        actionSheet.addAction(UIAlertAction(title: "ファイルを削除", style: .destructive, handler: { action in
            print("ファイル削除処理")
        }))
        actionSheet.addAction(.init(title: "キャンセル", style: .cancel, handler: nil))

        present(actionSheet, animated: true, completion: nil)
    }
    
    private func showAlert(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    private func updateAddedMyBookButton(isAddedMyBook: Bool) {
        UIView.setAnimationsEnabled(false)
        defer {
            UIView.setAnimationsEnabled(true)
        }
        if isAddedMyBook {
            addMyBookButton.setTitle("MyBooksから外す", for: .normal)
            addMyBookButton.layer.borderWidth = 1
            let color = UIColor.lightGray
            addMyBookButton.layer.borderColor = color.cgColor
            addMyBookButton.setTitleColor(color, for: .normal)
            addMyBookButton.layer.cornerRadius = 4.0
        } else {
            addMyBookButton.setTitle("MyBooks追加", for: .normal)
            addMyBookButton.layer.borderWidth = 1
            let color = UIColor.systemPink
            addMyBookButton.layer.borderColor = color.cgColor
            addMyBookButton.setTitleColor(color, for: .normal)
            addMyBookButton.layer.cornerRadius = 4.0
        }
    }
}
