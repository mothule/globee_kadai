//
//  BookListViewController.swift
//  globee_kadai
//
//  Created by motoki kawakami on 2020/07/06.
//  Copyright © 2020 mothule. All rights reserved.
//

import UIKit


class BookListViewController: UIViewController, Storyboardable {
    @IBOutlet private weak var tableView: UITableView!

    // TODO: 型を用意する
    private var bookList: TopCategorizedBookLine? = nil {
        didSet {
            tableView?.reloadData()
        }
    }
    
    func setup(bookList: TopCategorizedBookLine) {
        self.bookList = bookList
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeTable()
    }
}

extension BookListViewController: UITableViewDataSource {
    private func initializeTable() {
        tableView.dataSource = self
        tableView.estimatedRowHeight = 240.0
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        bookList?.subCategoryList.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(BookSubCategoryTableViewCell.self, for: indexPath)
        
        if let subCategory = bookList?.subCategoryList[safe: indexPath.row] {
            cell.setup(with: subCategory)
        }
        
        return cell
        
    }
}

class BookSubCategoryTableViewCell: UITableViewCell, Nibable {
    enum Notice: Notificationable {
        case selectBook(Book?)
        
        var noticeUserInfo: [AnyHashable : Any]? {
            if case .selectBook(let book) = self {
                return ["book": book!]
            }
            return nil
        }
        var noticeName: String { "BookSubCategoryTableViewCellSelectBook" }
    }
        
    @IBOutlet private weak var categoryName: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private var subCategory: SubCategorizedBookLine? = nil {
        didSet {
            collectionView?.reloadData()
        }
    }
    private var bookList: [Book] {
        subCategory?.bookList ?? []
    }
    
    func setup(with subCategory: SubCategorizedBookLine) {
        initializeCollection()
        self.subCategory = subCategory
        categoryName.text = subCategory.nameCategory
    }
}

extension BookSubCategoryTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    private func initializeCollection() {
        collectionView.dataSource = self
        collectionView.delegate = self
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0.0
        layout.minimumLineSpacing = 0.0
        layout.sectionInset = .zero
        layout.itemSize = .init(width: 110, height: 150)
        
        collectionView.collectionViewLayout = layout
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        bookList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(BookCollectionViewCell.self, for: indexPath)
        if let book = bookList[safe: indexPath.row] {
            cell.setup(with: book)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        guard let book = bookList[safe: indexPath.row] else { return }
        Notice.selectBook(book).post()
    }
}

class BookCollectionViewCell: UICollectionViewCell, Nibable {
    @IBOutlet private weak var imageView: BookImageView!    
    func setup(with book: Book) {
        imageView.setup(with: book.imageUrl)
    }
}
