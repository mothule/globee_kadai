//
//  ViewController.swift
//  globee_kadai
//
//  Created by motoki kawakami on 2020/07/03.
//  Copyright © 2020 mothule. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
     
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
}
