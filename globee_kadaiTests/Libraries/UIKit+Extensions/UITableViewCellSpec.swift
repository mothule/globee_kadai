//
//  UITableViewCellSpec.swift
//  
//
//  Created by motoki kawakami on 2020/07/12.
//  Copyright © 2020 mothule. All rights reserved.
//

import Foundation
import Quick
import Nimble

@testable import globee_kadai

class UITableViewCellSpec: QuickSpec {
    override func spec() {
        describe("UITableView + Cell extension") {
            it("") {
                let tableView: UITableView = .init(frame: .init(x: 0, y: 0, width: 100, height: 100), style: .plain)
                tableView.register(HogeTableViewCell.self)
                tableView.dequeueReusableCell(HogeTableViewCell.self, for: .init(row: 0, section: 0))
                
                tableView.register(FugaTableViewCell.self)
                tableView.dequeueReusableCell(FugaTableViewCell.self, for: .init(row: 0, section: 0))
            }
        }
    }
}

private class HogeTableViewCell: UITableViewCell {}
class FugaTableViewCell: UITableViewCell, Nibable {
    static var nib: UINib {
        let bundle = Bundle(for: self)
        return UINib(nibName: nibName, bundle: bundle)
    }
}
