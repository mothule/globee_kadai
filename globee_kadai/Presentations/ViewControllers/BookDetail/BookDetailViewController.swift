//
//  BookDetailViewController.swift
//  globee_kadai
//
//  Created by motoki kawakami on 2020/07/03.
//  Copyright © 2020 mothule. All rights reserved.
//

import UIKit
import PKHUD

protocol BookDetailViewer {
    func updateAddedMyBookButton(isAddedMyBook: Bool)
    func showProgress()
    func hideProgress()
    func showAlert(message: String)
}

class BookDetailViewController: UIViewController, Storyboardable {
    @IBOutlet private weak var bookImageView: BookImageView!
    @IBOutlet private weak var bookTitleLabel: UILabel!
    @IBOutlet private weak var firstLineLabel: UILabel!
    @IBOutlet private weak var secondLineLabel: UILabel!
    @IBOutlet private weak var addMyBookButton: UIButton!
    @IBOutlet private weak var purchaseButton: UIButton!
    
    private let repository: MyBookRepository = MyBookRepositoryImpl()
    
    private var presenter: BookDetailPresenter!
    private var book: Book { presenter.book }

    func setup(book: Book) {
        self.presenter = BookDetailPresenterImpl(repository: MyBookRepositoryImpl(), viewer: self, book: book)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.topItem?.title = "書籍紹介"

        bookImageView.setup(with: book.imageUrl)
        
        bookTitleLabel.attributedText = book.nameBook.decorate(by: [.lineHeight(bookTitleLabel.font.pointSize * 1.4)])
        
        let lineTexts = presenter.authorAndPublisher()
        firstLineLabel.text = lineTexts[0]
        secondLineLabel.text = lineTexts[1]

        purchaseButton.layer.cornerRadius = 4.0
        purchaseButton.backgroundColor = Theme.color.accent
        purchaseButton.setTitleColor(.white, for: .normal)
        purchaseButton.setTitle("購入", for: .normal)
        
        let deleteButton = UIBarButtonItem(title: "データ削除", style: .plain, target: self, action: #selector(onTouchedDeleteDataOnNavBar(_:)))
        deleteButton.tintColor = Theme.color.accent
        navigationItem.rightBarButtonItem = deleteButton
        
        presenter.fetchBook()
    }
    
    @IBAction func onTouchedAddMyBooksButton(_ sender: Any) {
        presenter.toggleMyBook()
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

extension BookDetailViewController: BookDetailViewer {
    func updateAddedMyBookButton(isAddedMyBook: Bool) {
        UIView.setAnimationsEnabled(false)
        defer {
            UIView.setAnimationsEnabled(true)
        }
        let color: UIColor
        let title: String
        if isAddedMyBook {
            title = "MyBooksから外す"
            color = Theme.color.secondary
        } else {
            title = "MyBooks追加"
            color = Theme.color.accent
        }
        addMyBookButton.setTitle(title, for: .normal)
        addMyBookButton.layer.borderWidth = 1
        addMyBookButton.layer.borderColor = color.cgColor
        addMyBookButton.setTitleColor(color, for: .normal)
        addMyBookButton.layer.cornerRadius = 4.0
        addMyBookButton.layoutIfNeeded()
    }
    
    func showProgress() { ProgressHUD.show() }
    func hideProgress() { ProgressHUD.hide() }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

}
