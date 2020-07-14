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

extension BookSubCategoryTableViewCell: UICollectionViewDataSource {
    private func initializeCollection() {
        collectionView.dataSource = self
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
}

class BookCollectionViewCell: UICollectionViewCell, Nibable {
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var aspectConstraint: NSLayoutConstraint!
    
    func setup(with book: Book) {
        imageView.sd_setImageWithFadeIn(url: book.imageUrl) { [weak self] _ in
            self?.setupShadow()
        }
    }
    
    private func setupShadow() {
        imageView.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOpacity = 0.7
        imageView.layer.shadowRadius = 1
        imageView.layer.masksToBounds = false
    }
}
