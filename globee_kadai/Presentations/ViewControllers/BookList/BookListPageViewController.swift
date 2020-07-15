//
//  BookListPageViewController.swift
//  globee_kadai
//
//  Created by motoki kawakami on 2020/07/08.
//  Copyright © 2020 mothule. All rights reserved.
//

import Foundation
import UIKit


class BookListPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    enum Notice: Notificationable {
        case changedPage(Int)
        var noticeName: String { "BookListPageViewControllerChangedPage" }
        var noticeUserInfo: [AnyHashable : Any]? {
            if case .changedPage(let index) = self {
                return ["index": index]
            }
            return nil
        }
    }
    
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
        delegate = self
    }
    
    func navigateViewControllerDirect(at nextIndex: Int, from beforeIndex: Int) {
        guard beforeIndex != nextIndex else { return }
        guard let vc = pageContents[safe: nextIndex] else { return }
        
        let direction: NavigationDirection = beforeIndex > nextIndex ? .reverse : .forward
        setViewControllers([vc], direction: direction, animated: true, completion: nil)
    }
    
    private func bookListViewController(bookList: TopCategorizedBookLine) -> BookListViewController {
        let vc = BookListViewController.instance()
        vc.setup(bookList: bookList)
        return vc
    }
    
    // MARK: - UIPageViewControllerDelegate
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let bookListViewController = pageViewController.viewControllers?.first as? BookListViewController else { return }
        guard let index = pageContents.firstIndex(of: bookListViewController) else { return }
        Notice.changedPage(index).post()
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
