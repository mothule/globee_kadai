//
//  BookListViewController.swift
//  globee_kadai
//
//  Created by motoki kawakami on 2020/07/06.
//  Copyright © 2020 mothule. All rights reserved.
//

import UIKit


class BookListViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    
    // TODO: 型を用意する
    private var bookList: BookListGetResponse? = nil {
        didSet {
            tableView?.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeTable()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let req = BookListGetRequest()
        APIClient.shared.send(request: req) { [weak self] result in
            switch result {
            case .success(let response):
                let bookList = BookListGetResponse.parse(from: response.value).first
                self?.bookList = bookList
                
            case .failure(let error):
                debugPrint(error)
            }
        }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookSubCategoryTableViewCell", for: indexPath) as! BookSubCategoryTableViewCell
        
        if let subCategory = bookList?.subCategoryList[safe: indexPath.row] {
            cell.setup(with: subCategory)
        }
        
        return cell
        
    }
}

class BookSubCategoryTableViewCell: UITableViewCell {
    @IBOutlet private weak var categoryName: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView!
    private var subCategory: SubCategory? = nil {
        didSet {
            collectionView?.reloadData()
        }
    }
    private var bookList: [Book] {
        subCategory?.bookList ?? []
    }
    
    func setup(with subCategory: SubCategory) {
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
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookCollectionViewCell", for: indexPath) as! BookCollectionViewCell
        
        if let book = bookList[safe: indexPath.row] {
            cell.setup(with: book)
        }
        return cell
    }
}

class BookCollectionViewCell: UICollectionViewCell {
    @IBOutlet private weak var imageView: UIImageView!
    
    @IBOutlet weak var aspectConstraint: NSLayoutConstraint!
    
    private var notification: Notification {
        .init(name: Notification.Name(rawValue: "BookCollectionViewCell"))
    }
    
    func setup(with book: Book) {
        guard let url = URL(string: book.imageUrl) else { return }
        URLSession.shared.dataTask(with: url) { [weak self] (data, res, error) in
            guard let self = self else { return }
            if let data = data {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.setImage(image)
                        NotificationCenter.default.post(self.notification)
                    }
                }
            }
        }.resume()
        
        
    }
    
    func setImage(_ image: UIImage) {
        imageView.image = image
        
        imageView.layer.shadowOffset = CGSize(width: 1.0, height: 1.0)
        imageView.layer.shadowColor = UIColor.black.cgColor
        imageView.layer.shadowOpacity = 0.7
        imageView.layer.shadowRadius = 1
        imageView.layer.masksToBounds = false
    }
    
    
}
