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
    private var bookCollection: BookCollection = .init() {
        didSet {
            pageContents = bookCollection.topCategorizedBookLineList.map { bookListViewController(bookList: $0) }
        }
    }
    private var pageContents: [BookListViewController] = []
    
    func setup(bookCollection: BookCollection) {
        self.bookCollection = bookCollection
        setViewControllers([pageContents.first!],
                           direction: .forward,
                           animated: true,
                           completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataSource = self
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
    
    private func bookListViewController(bookList: TopCategorizedBookLine) -> BookListViewController {
        let vc = BookListViewController.instance()
        vc.setup(bookList: bookList)
        return vc
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
