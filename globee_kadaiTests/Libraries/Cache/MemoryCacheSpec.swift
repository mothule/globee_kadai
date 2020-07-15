//
//  MemoryCacheSpec.swift
//  
//
//  Created by motoki kawakami on 2020/07/09.
//  Copyright © 2020 mothule. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import globee_kadai

class MemoryCacheSpec: QuickSpec {
    override func spec() {
        describe("Cache<T>") {
            var expireTime: TimeInterval?
            let key: String = "key"
            var object: String = ""
            var subject: Cache<String>!
            
            beforeEach {
                object = "asdf"
                expireTime = 10.minute
                subject = Cache<String>(key: key, expireTime: expireTime)
            }
            
            context("生成直後") {
                it("nilを返す") {
                    let sub = Cache<String>(key: "hoge", expireTime: 1.minute)
                    expect(sub.value).to(beNil())
                }
            }
            
            context("値セットして期限内") {
                beforeEach {
                    subject.value = object
                }
                it("値を返す") {
                    expect(subject.value).notTo(beNil())
                    expect(subject.value).to(equal(object))
                }
            }
            
            context("値セット後に期限切れ") {
                beforeEach {
                    subject.value = object
                    subject.invalidate()
                }
                it("nilを返す") { expect(subject.value).to(beNil()) }
            }
            
            context("期限切れ後に値をセット") {
                beforeEach {
                    subject.value = "hoge"
                    subject.invalidate()
                    subject.value = object
                }
                it("値を返す") {
                    expect(subject.value).notTo(beNil())
                    expect(subject.value).to(equal(object))
                }
            }
            
            context("値が未設定なら") {
                beforeEach {
                    subject = Cache<String>(key: "fuga", expireTime: expireTime)
                }
                it("nilを返す") { expect(subject.value).to(beNil()) }
            }
            
            context("初期化時に期限なし指定") {
                beforeEach {
                    subject = Cache<String>(key: key, expireTime: nil)
                    subject.value = object
                }
                it("値を返す") {
                    expect(subject.value).notTo(beNil())
                    expect(subject.value).to(equal(object))
                }
            }
        }
    
        describe("MemoryCache") {
            var subject: MemoryCache!
            var key: String { return "hoge" }
            var value: String?
            
            beforeEach { subject = MemoryCache() }
            
            describe("clearAll()") {
                it("") {
                    value = "hoge"
                    subject.set(key: key, value: value, expireTime: 1.minute)
                    expect(subject.cachedObjectsCount) == 1
                    subject.clearAll()
                    expect(subject.cachedObjectsCount) == 0
                }
            }

            describe("invalidate(key:)") {
                context("キーがある") {
                    it("") {
                        value = "hoge"
                        subject.set(key: key, value: value, expireTime: 1.minute)
                        var v: String? = subject.get(key: key)
                        expect(v).toNot(beNil())
                        
                        subject.invalidate(key: key)
                        v = subject.get(key: key)
                        expect(v).to(beNil())
                    }
                }
                
                context("キーがない") {
                    it("クラッシュしない") {
                        subject.invalidate(key: "not found key")
                    }
                }
                
                context("キーの期限が未設定(nil)") {
                    it("nil返す") {
                        value = "hoge"
                        subject.set(key: key, value: value)
                        subject.invalidate(key: key)
                        let v: String? = subject.get(key: key)
                        expect(v).to(beNil())
                    }
                }
            }


            describe("任意型の値をオンメモリで保持できる") {
                it("StoreとGetができる") {
                    value = "hoge"
                    subject.set(key: key, value: value, expireTime: 1.minute)
                    expect(subject.get(key: key)) == value
                }
                
                context("キーがなければ") {
                    it("nilを返す") {
                        let value: String? = subject.get(key: "not found key")
                        expect(value).to(beNil())
                    }
                }
                
                context("期限が過ぎれば") {
                    it("Getしてもnilになる") {
                        value = "hoge"
                        subject.set(key: key, value: value, expireTime: 1.second)
                        Thread.sleep(forTimeInterval: 1.1)
                        let actual: String? = subject.get(key: key)
                        expect(actual).to(beNil())
                    }
                }
                
                describe("無期限してもできる") {
                    it("StoreとGetができる") {
                        value = "hoge"
                        subject.set(key: key, value: value)
                        expect(subject.get(key: key)) == value
                    }
                }
            }
            
            describe("保持データをdumpできる") {
                it("1行1データ形式で返す") {
                    subject.set(key: "A", value: "a", expireTime: 1.second)
                    subject.set(key: "B", value: "b", expireTime: 1.minute)
                    subject.set(key: "C", value: "c")
                    subject.set(key: "D")
                    
                    let dumpString = subject.dump()
                    let strings = dumpString.split(separator: "\n")
                    print("strings => \(strings)")
                    expect(strings).to(haveCount(4))
                }
            }            
        }

    }
}
