//
//  UICollectionViewCellSpec.swift
//  
//
//  Created by motoki kawakami on 2020/07/12.
//  Copyright © 2020 mothule. All rights reserved.
//

import Foundation
import Quick
import Nimble

@testable import globee_kadai

class UICollectionViewCellSpec: QuickSpec {
    override func spec() {
        describe("UICollectionView + Cell extension") {
            it("") {
                let layout: UICollectionViewFlowLayout = .init()
                let collectionView: UICollectionView = .init(frame: .init(x: 0, y: 0, width: 100, height: 100), collectionViewLayout: layout)
                collectionView.register(HogeCollectionViewCell.self)
                collectionView.register(FugaCollectionViewCell.self)
                collectionView.registerSupplementaryView(CollectionHeaderView.self, kindOf: UICollectionView.elementKindSectionHeader)

                collectionView.dequeueReusableCell(HogeCollectionViewCell.self, for: .init(row: 0, section: 0))
                collectionView.dequeueReusableCell(FugaCollectionViewCell.self, for: .init(row: 0, section: 0))
                collectionView.dequeueReusableSupplementaryView(CollectionHeaderView.self,
                                                                ofKind: UICollectionView.elementKindSectionHeader,
                                                                for: .init(row: 0, section: 0))
            }
        }
    }
}

private class HogeCollectionViewCell: UICollectionViewCell {}
class FugaCollectionViewCell: UICollectionViewCell, Nibable {
    static var nib: UINib {
        let bundle = Bundle(for: self)
        return UINib(nibName: nibName, bundle: bundle)
    }
}
class CollectionHeaderView: UICollectionReusableView, Nibable {
    static var nib: UINib {
        let bundle = Bundle(for: self)
        return UINib(nibName: nibName, bundle: bundle)
    }
}
