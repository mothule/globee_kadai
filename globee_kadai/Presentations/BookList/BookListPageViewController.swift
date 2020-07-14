//
//  BookListPageViewController.swift
//  globee_kadai
//
//  Created by motoki kawakami on 2020/07/08.
//  Copyright © 2020 mothule. All rights reserved.
//

import Foundation
import UIKit


class BookListPageViewController: UIPageViewController, UIPageViewControllerDataSource {
    
    // TODO: 型を用意する
    private var bookList: [BookListGetResponse] = [] 
    private var pageContents: [BookListViewController] = []
    
    func setup(bookList: [BookListGetResponse]) {
        self.bookList = bookList
        pageContents = bookList.map { bookListViewController(bookList: $0) }
        setViewControllers([pageContents.first!],
                           direction: .forward,
                           animated: true,
                           completion: nil)
    }
    
    func navigateViewControllerDirect(at nextIndex: Int, from beforeIndex: Int) {
        guard beforeIndex != nextIndex else { return }
        guard let vc = pageContents[safe: nextIndex] else { return }
        
        let direction: NavigationDirection
        if beforeIndex > nextIndex {
            direction = .reverse
        } else {
            direction = .forward
        }
        
        setViewControllers([vc], direction: direction, animated: true, completion: nil)
    }
    
    private func bookListViewController(bookList: BookListGetResponse) -> BookListViewController {
        let vc = BookListViewController.instance()
        vc.setup(bookList: bookList)
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
        
        // TODO: view.subviewsからUIScrollViewを見つけてdelegateをセットし、
        // 一番左と右のスクロールをしようとしたらスクロール位置をクランプさせる
    }
    
    // MARK: - UIPageViewControllerDataSource
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let bookListViewController = viewController as? BookListViewController else { return nil }
        guard let index = pageContents.firstIndex(of: bookListViewController) else { return nil }

        let nextIndex: Int = max(index - 1, 0)
        if index == nextIndex { return nil }
        
        return pageContents[safe: nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let bookListViewController = viewController as? BookListViewController else { return nil }
        guard let index = pageContents.firstIndex(of: bookListViewController) else { return nil }

        let nextIndex: Int = min(index + 1, pageContents.count - 1)
        if index == nextIndex { return nil }

        return pageContents[safe: nextIndex]
    }
}
