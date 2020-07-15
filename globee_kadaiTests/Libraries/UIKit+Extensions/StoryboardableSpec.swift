//
//  StoryboardableSpec.swift
//  
//
//  Created by motoki kawakami on 2020/07/12.
//  Copyright © 2020 mothule. All rights reserved.
//

import Foundation
import Quick
import Nimble

@testable import globee_kadai

class StoryboardableSpec: QuickSpec {
    override func spec() {
        describe("Storyboardable") {
            describe("instantiate()") {
                it("") {
                    let bundle = Bundle(for: HogeViewController.self)
                    let vc = HogeViewController.instance(bundle: bundle)
                    expect(String(describing: vc)).to(contain("HogeViewController"))
                }
                
                it("") {
                    let bundle = Bundle(for: Hoge2ViewController.self)
                    let vc = Hoge2ViewController.instance(bundle: bundle)
                    expect(String(describing: vc)).to(contain("Hoge2ViewController"))
                }

            }
        }
    }
}

class HogeViewController: UIViewController, Storyboardable {}
class Hoge2ViewController: UIViewController, Storyboardable {
    static var storyboardName: String { "HogeViewController" }
}
