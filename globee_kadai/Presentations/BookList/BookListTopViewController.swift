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
    // TODO: モデル用意
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
        
        initializeCollectionView()
        
        title = "見つける"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .never
        
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
    
    private func onUpdatedBookCollection() {
        pageViewController?.setup(bookCollection: bookCollection)
        headerTabView?.reloadData()
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

class HeaderTabCollectionCell: UICollectionViewCell, Nibable {
    @IBOutlet private weak var label: UILabel!
    @IBOutlet private weak var underLine: UIView!
        
    func setup(label: String?, isActive: Bool) {
        self.label.text = label.orEmpty
        self.label.textColor = isActive ? #colorLiteral(red: 0.9628371596, green: 0.03040463105, blue: 0.4038784206, alpha: 1) : #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)

        self.underLine.layer.cornerRadius = 4
        self.underLine.isShown = isActive
        self.underLine.backgroundColor = #colorLiteral(red: 0.9628371596, green: 0.03040463105, blue: 0.4038784206, alpha: 1)
    }
}
