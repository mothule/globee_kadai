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
    private var headerTabViewController: UIViewController?
    @IBOutlet private weak var pageViewContainer: UIView!
    
    
    
    private var tabItems: [String] {
        ["すべて", "Unlimited", "TOEIC", "英検", "英会話"]
    }
    private var currentPageIndex: Int = 0

    

//    07/03 14:37 ~ 20:53
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initializeCollectionView()
        
        title = "見つける"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .never
        
//        navigationItem.prompt = "Prompt"
//        navigationItem.rightBarButtonItem = .init(title: "右ボタン", style: .plain, target: self, action: #selector(onTouchedRightButton(_:)))
//        navigationItem.leftBarButtonItem = .init(title: "右ボタン", style: .plain, target: self, action: #selector(onTouchedRightButton(_:)))

        
        
        

        let req = BookListGetRequest()
        APIClient.shared.send(request: req) { result in
            switch result {
            case .success(let response):
                let bookList = BookListGetResponse.parse(from: response.value)
                debugPrint(bookList)
                
            case .failure(let error):
                debugPrint(error)
            }
        }
        
    }
    
    @objc private func onTouchedRightButton(_ sender: AnyObject) {
        
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HeaderTabCollectionCell", for: indexPath) as! HeaderTabCollectionCell
        
        cell.setup(label: tabItems[safe: indexPath.row] ?? "", isActive: indexPath.row == currentPageIndex)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        currentPageIndex = indexPath.row
        collectionView.reloadData()
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}

class HeaderTabCollectionCell: UICollectionViewCell {
    @IBOutlet private weak var label: UILabel!
    @IBOutlet private weak var underLine: UIView!
    
    func setup(label: String, isActive: Bool) {
//        backgroundColor = UIColor.red
        self.label.text = label
        self.label.textColor = isActive ? #colorLiteral(red: 0.9628371596, green: 0.03040463105, blue: 0.4038784206, alpha: 1) : #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)

        self.underLine.layer.cornerRadius = 4
        self.underLine.isShown = isActive
        self.underLine.backgroundColor = #colorLiteral(red: 0.9628371596, green: 0.03040463105, blue: 0.4038784206, alpha: 1)
    }
}
