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
    
    private var book: Book!
    
    func setup(book: Book) {
        self.book = book
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bookImageView.setup(with: book.imageUrl)
        
        bookTitleLabel.attributedText = book.nameBook.decorate(by: [.lineHeight(bookTitleLabel.font.pointSize * 1.4)])
        authorLabel.text = "著者：" + book.author
        publisherLabel.text = "出版社：" + book.publisher
        addMyBookButton.layer.borderWidth = 1
        addMyBookButton.layer.borderColor = UIColor.systemPink.cgColor
        addMyBookButton.layer.cornerRadius = 4.0

        purchaseButton.layer.cornerRadius = 4.0
        purchaseButton.backgroundColor = UIColor.systemPink
        purchaseButton.setTitleColor(.white, for: .normal)
        purchaseButton.setTitle("購入", for: .normal)

        navigationController?.navigationBar.topItem!.title = "書籍紹介"
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "データ削除", style: .plain, target: self, action: #selector(onTouchedDeleteDataOnNavBar(_:)))
    }
    
    @IBAction func onTouchedAddMyBooksButton(_ sender: Any) {
        // プログレス表示
        
        let alert = UIAlertController(title: "", message: "MyBookへ追加しました。", preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
//        "MyBook追加に失敗しました。"
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
}
