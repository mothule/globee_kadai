//
//  BookListTopViewController.swift
//  globee_kadai
//
//  Created by motoki kawakami on 2020/07/03.
//  Copyright © 2020 mothule. All rights reserved.
//

import UIKit
import Alamofire

class BookListTopViewController: UIViewController {
    @IBOutlet private weak var headerTabView: UICollectionView!
    @IBOutlet private weak var pageViewContainer: UIView!
    private var pageViewController: BookListPageViewController!
    private var repository: BookCollectionRepository = BookCollectionRepositoryImpl()
    private var bookCollection: BookCollection = .init() {
        didSet {
            onUpdatedBookCollection()
        }
    }
    private var tabItems: [String] { bookCollection.topCategoryNames }
    private var currentPageIndex: Int = 0 {
        didSet {
            pageViewController?.navigateViewControllerDirect(at: currentPageIndex, from: oldValue)
            headerTabView?.reloadData()
            headerTabView?.scrollToItem(at: .init(item: currentPageIndex, section: 0), at: .centeredHorizontally, animated: true)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "見つける"

        initializeCollectionView()
        
        // embed page vc to container view.
        pageViewController = BookListPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal,
            options: nil)
        let pageView = pageViewController.view!
        self.pageViewContainer.addSubview(pageViewController.view)
        addChild(pageViewController)
        pageView.translatesAutoresizingMaskIntoConstraints = false
        pageView.leadingAnchor.constraint(equalTo: pageViewContainer.leadingAnchor).isActive = true
        pageView.trailingAnchor.constraint(equalTo: pageViewContainer.trailingAnchor).isActive = true
        pageView.topAnchor.constraint(equalTo: pageViewContainer.topAnchor).isActive = true
        pageView.bottomAnchor.constraint(equalTo: pageViewContainer.bottomAnchor).isActive = true
        pageViewController.didMove(toParent: self)

        // prepare remote contents
        repository.fetchAll().onSuccess({ [weak self] bookCollection in
            self?.bookCollection = bookCollection
        }).onFailure({ _ in
            // do not nothing
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        BookSubCategoryTableViewCell.Notice.selectBook(nil).addObserver(self, selector: #selector(onSelectedBook(_:)))
        BookListPageViewController.Notice.changedPage(0).addObserver(self, selector: #selector(onChangedPage(_:)))
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    private func onUpdatedBookCollection() {
        pageViewController?.setup(bookCollection: bookCollection)
        headerTabView?.reloadData()
    }
    
    @objc private func onSelectedBook(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
            let book = userInfo["book"] as? Book else { return }
        
        let vc = BookDetailViewController.instance()
        vc.setup(book: book)
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func onChangedPage(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
            let index = userInfo["index"] as? Int else { return }
        currentPageIndex = index
    }
}

extension BookListTopViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    private func initializeCollectionView() {
        headerTabView.dataSource = self
        headerTabView.delegate = self

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.itemSize = .init(width: 80, height: 48)
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumLineSpacing = 24
        flowLayout.sectionInset = .init(top: 0, left: 15, bottom: 0, right: 15)

        headerTabView.collectionViewLayout = flowLayout
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        tabItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(HeaderTabCollectionCell.self, for: indexPath)
        cell.setup(label: tabItems[safe: indexPath.row], isActive: indexPath.row == currentPageIndex)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        currentPageIndex = indexPath.row
    }
}
