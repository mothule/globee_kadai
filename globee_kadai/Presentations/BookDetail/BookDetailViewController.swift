//
//  BookDetailViewController.swift
//  globee_kadai
//
//  Created by motoki kawakami on 2020/07/03.
//  Copyright © 2020 mothule. All rights reserved.
//

import UIKit

class BookDetailViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    
        navigationItem.backBarButtonItem?.title = "書籍紹介"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "データ削除", style: .plain, target: self, action: #selector(onTouchedDeleteDataOnNavBar(_:)))
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
