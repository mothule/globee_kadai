//
//  NotificationSpec.swift
//  
//
//  Created by motoki kawakami on 2020/07/09.
//  Copyright © 2020 mothule. All rights reserved.
//

import Foundation

import Quick
import Nimble
@testable import globee_kadai

class NotificationableSpec: QuickSpec {
    
    var waiter: XCTestExpectation!

    override func spec() {
        describe("Error extension") {
            describe("toDictionary prop") {
                it("errorキーで自身を格納したDictionaryを返す") {
                    let error: Error = NSError(domain: "domain", code: 1234, userInfo: ["error": "asdf"])
                    
                    let dic = error.toDictionary
                    let e = dic["error"]! as NSError
                    expect(e).to(equal(error as NSError))
                }
            }
        }
        
        describe("Notificationable") {
            describe("makeNotification(object:)") {
                it("name is noticeName") {
                    let subject = FugaNotice.hoge.makeNotification()
                    expect(subject.name.rawValue) == FugaNotice.hoge.noticeName
                }
                context("When with object") {
                    it("object is Notification.object") {
                        let subject = HogeNotice.fetched.makeNotification(object: "String")
                        expect(subject.object! as? String) == "String"
                    }
                }
                context("When with noticeUserInfo") {
                    it("") {
                        let nsError = NSError(domain: "domain", code: 1234, userInfo: ["key": "value"])
                        let subject = HogeNotice.fetchError(nsError).makeNotification()
                        expect(subject.name.rawValue) == HogeNotice.fetchError(nsError).noticeName
                        
                        expect(subject.userInfo?.hasKey("error")) == true
                        let error = subject.userInfo?["error"] as? NSError
                        expect(error).toNot(beNil())
                        expect(error?.userInfo.hasKey("key")) == true
                    }
                }
            }

            describe("post(object:)") {
                it("") {
                    let nsError = NSError(domain: "domain", code: 1234, userInfo: ["key": "value"])

                    expect {
                        HogeNotice.fetchError(nsError).post()
                    }.to(postNotifications(contain([
                        HogeNotice.fetchError(nsError).makeNotification()
                    ])))
                }
            }
            
            describe("addObserver(_:selector:object:)") {
                it("") {
                    self.waiter = .init(description: "addObserver")
                    HogeNotice.fetched.addObserver(self, selector: #selector(self.fetched(_:)))
                    HogeNotice.fetched.post()
                    self.wait(for: [self.waiter], timeout: 3)
                }
            }
        }
    }
    
    @objc func fetched(_ notification: Notification) {
        waiter.fulfill()
    }
}

private enum FugaNotice: Notificationable {
    case hoge
    var noticeName: String { "FugaNoticehoge" }
}

private enum HogeNotice: Notificationable {
    case fetched
    case fetchError(Error?)
    
    var noticeName: String {
        switch self {
        case .fetched: return "HogeNoticeFetched"
        case .fetchError: return "HogeNoticeFetchError"
        }
    }
    
    var noticeUserInfo: [AnyHashable : Any]? {
        switch self {
        case .fetched: return nil
        case .fetchError(let error): return error?.toDictionary ?? [:]
        }
    }
}
