//
//  EzTaskSpec.swift
//  
//
//  Created by motoki kawakami on 2020/07/09.
//  Copyright © 2020 mothule. All rights reserved.
//

import Foundation
import Quick
import Nimble
@testable import globee_kadai

class EzTaskSpec: QuickSpec {
    override func spec() {
        describe("EzTask") {
            
            typealias Task = EzTask<Int, NSError>
            var subject: Task!
            
            beforeEach {
                subject = Task { fulfill, reject in fulfill(1) }
            }
            
            describe("init(paused:process:)") {
                context("pausedがtrueなら") {
                    it("resumeするまで実行しない") {
                        var signal: Bool = false
                        
                        let task = Task(paused: true, process: { (ok, _) in
                            DispatchQueue.global().async {
                                Thread.sleep(forTimeInterval: 0.5)
                                DispatchQueue.main.async {
                                    ok(5)
                                }
                            }
                        }).onSuccess({ (val) in
                            expect(val) == 5
                            signal = true
                        })
                        expect(signal) == false
                        task.resume()
                        expect(signal).toEventually(beTrue(), timeout: 10.0)
                    }
                }
            }

            
            describe("init(process:)") {
                var signal: Bool = false
                beforeEach { signal = false }

                context("fulfillが呼ばれる") {
                    beforeEach { subject = Task { fulfill, reject in signal = true; fulfill(5) } }
                    it("タスク成功状態となる") {
                        if case .success(let response) = subject.state {
                            expect(response) == 5
                        } else { fail() }
                    }
                    it("渡したクロージャを実行する") { expect(signal) == true }
                }
                context("rejectが呼ばれる") {
                    var error: Error!
                    beforeEach {
                        error = NSError(domain: "hoge", code: -2, userInfo: nil)
                        subject = Task { fulfill, reject in signal = true; reject(error as NSError) }
                    }
                    it("タスク失敗状態となる") {
                        if case .failure(let error) = subject.state {
                            expect(error) == error
                        } else { fail() }
                    }
                    it("渡したクロージャを実行する") { expect(signal) == true }
                }
            }
            
            describe("init(fulfill:)") {
                it("初めからタスク成功状態") {
                    subject = Task(fulfill: 1)
                    if case .success(let response) = subject.state {
                        expect(response) == 1
                    } else { fail() }
                }
            }
            
            describe("init(reject:)") {
                it("初めからタスク失敗状態") {
                    let error = NSError(domain: "hoge", code: -1, userInfo: nil)
                    subject = Task(reject: error)
                    if case .failure(let error) = subject.state {
                        expect(error) == error
                    } else { fail() }
                }
            }


            
            describe("onSuccess(closure:) or onFailure(closure:) or on(closure:)") {
                var signal: String = ""
                let successSignal = "success"
                let failureSignal = "failure"
                let finishSignal = "finish"
                var response: Int?
                var error: NSError?
                
                beforeEach {
                    signal = ""
                    response = nil
                    error = nil
                }
                
                context("タスク未実施状態なら") {
                    beforeEach { subject = Task { _, _ in }.onFinish { _, _ in } }
                    it("いずれのコールバックも呼ばない") { expect(signal) == "" }
                    it("タスク完了状態ではない") { expect(subject.state.isFinished) == false }
                }
                
                context("タスクが既に完了状態なら") {
                    beforeEach { subject = Task { f, _ in f(1) }.onFinish { _, _ in }.onSuccess { res in } }
                    it("いずれのコールバックも呼ばない") { expect(signal) != failureSignal }
                }
                
                context("成功コールバック実行可能なら") {
                    beforeEach {
                        subject = Task { f, _ in f(5) }.onSuccess { res in
                            signal = successSignal;
                            response = res
                        }
                    }
                    it("成功コールバックを呼ぶ") { expect(signal) == successSignal }
                    it("成功コールバックでレスポンスを受け取る") { expect(response).toNot(beNil()) }
                    it("タスク完了状態になる") { expect(subject.state.isFinished) == true }
                }
                context("失敗コールバック実行可能なら") {
                    beforeEach {
                        subject = Task { _, r in r(NSError(domain: "hoge", code: -1, userInfo: nil)) }.onFailure { err in
                            signal = failureSignal;
                            error = err
                        }
                    }
                    it("失敗コールバックを呼ぶ") { expect(signal) == failureSignal }
                    it("失敗コールバックでエラーを受け取る") { expect(error).toNot(beNil()) }
                    it("タスク完了状態になる") { expect(subject.state.isFinished) == true }
                }
                context("完了コールバック実行可能なら") {
                    context("しかも失敗状態なら") {
                        beforeEach {
                            subject = Task { _, reject in
                                reject(NSError(domain: "hoge", code: -1, userInfo: nil))
                            }.onFinish { res, err in
                                signal = finishSignal;
                                response = res
                                error = err
                            }
                        }
                        it("タスク完了状態になる") { expect(subject.state.isFinished) == true }
                        it("完了コールバックを呼ぶ") { expect(signal) == finishSignal }
                        it("完了コールバックでレスポンスを受け取らない") { expect(response).to(beNil()) }
                        it("完了コールバックでエラーを受け取る") { expect(error).toNot(beNil()) }
                    }
                    
                    context("しかも成功状態なら") {
                        beforeEach {
                            subject = Task { fulfill, _ in
                                fulfill(5)
                            }.onFinish { res, err in
                                signal = finishSignal;
                                response = res
                                error = err
                            }
                        }
                        it("タスク完了状態になる") { expect(subject.state.isFinished) == true }
                        it("完了コールバックを呼ぶ") { expect(signal) == finishSignal }
                        it("完了コールバックでレスポンスを受け取る") { expect(response).toNot(beNil()) }
                        it("完了コールバックでエラーを受け取らない") { expect(error).to(beNil()) }
                    }
                }
            }
            
            describe("canSuccessClosureExecutable propery") {
                var sub: Bool { return subject.canSuccessClosureExecutable }
                context("成功コールバックが設定済みなら") {
                    beforeEach { subject.onSuccess { _ in } }
                    it("trueを返す") { expect(sub) == true }
                }
                context("完了コールバックが設定済みなら") {
                    beforeEach { subject.onFinish { _, _ in } }
                    it("trueを返す") { expect(sub) == true }
                }
                context("どちらも未設定なら") {
                    it("falseを返す") { expect(sub) == false }
                }
            }
            
            describe("canFailureClosureExecutable propery") {
                var sub: Bool { return subject.canFailureClosureExecutable }
                context("成功コールバックが設定済みなら") {
                    beforeEach { subject.onFailure { _ in } }
                    it("trueを返す") { expect(sub) == true }
                }
                context("完了コールバックが設定済みなら") {
                    beforeEach { subject.onFinish { _, _ in } }
                    it("trueを返す") { expect(sub) == true }
                }
                context("どちらも未設定なら") {
                    it("falseを返す") { expect(sub) == false }
                }
            }
            
            describe("onThen(:)") {
                context("最初のタスクは成功すれば") {
                    it("タスクを順番に実行する") {
                        
                        var signal: String = ""
                        Task({ (ok, ng) in
                            DispatchQueue.global().async {
                                Thread.sleep(forTimeInterval: 1.5)
                                DispatchQueue.main.async {
                                    ok(5)
                                }
                            }
                        }).onSuccess({ (val) in
                            signal += "\(val)"
                        }).onThen({ (ok, ng) in
                            DispatchQueue.global().async {
                                Thread.sleep(forTimeInterval: 0.5)
                                DispatchQueue.main.async {
                                    ok(10)
                                }
                            }
                        }).onSuccess({ (val) in
                            signal += "\(val)"
                        })
                        
                        expect(signal).toEventually(equal("510"), timeout: 10.0)
                    }
                }
                
                context("最初のタスクが失敗したら") {
                    it("タスクは実行しない") {
                        
                        var signal: String = ""
                        Task({ (ok, ng) in
                            DispatchQueue.global().async {
                                Thread.sleep(forTimeInterval: 1.5)
                                DispatchQueue.main.async {
                                    ng(NSError(domain: "hoge", code: -1, userInfo: nil))
                                }
                            }
                        }).onSuccess({ (val) in
                            fail()
                        }).onFailure({ (error) in
                            signal = "fail"
                        }).onThen({ (ok, ng) in
                            fail()
                        }).onSuccess({ (val) in
                            fail()
                        }).onFailure({ (error) in
                            fail()
                        })
                        
                        expect(signal).toEventually(equal("fail"), timeout: 10.0)
                    }
                }
                
                context("タスクを2つ以上連結しても") {
                    it("タスクは上から順に実行する") {
                        var signal: String = ""
                        
                        Task({ ok, ng in
                            DispatchQueue.global().async {
                                Thread.sleep(forTimeInterval: 1.5)
                                DispatchQueue.main.async {
                                    ok(5)
                                }
                            }
                        }).onSuccess({ (val) in
                            signal += "\(val)"
                        }).onThen({ ok, ng in
                            DispatchQueue.global().async {
                                Thread.sleep(forTimeInterval: 0.5)
                                DispatchQueue.main.async {
                                    ok(10)
                                }
                            }
                        }).onSuccess({ (val) in
                            signal += "\(val)"
                        }).onThen({ ok, ng in
                            DispatchQueue.global().async {
                                Thread.sleep(forTimeInterval: 0.25)
                                DispatchQueue.main.async {
                                    ok(25)
                                }
                            }
                        }).onSuccess({ (val) in
                            signal += "\(val)"
                        })
                        
                        expect(signal).toEventually(equal("51025"), timeout: 5.0)
                    }
                }
            }




        }
    }
}

