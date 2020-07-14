//
//  EzTask.swift
//  
//
//  Created by motoki kawakami on 2020/07/09.
//  Copyright © 2020 mothule. All rights reserved.
//

import Foundation

class EzTask<Response, E> {
    typealias MyType = EzTask<Response, E>
    typealias Process = ((fulfill: SuccessClosure, reject: FailureClosure)) -> Void
    typealias SuccessClosure = (Response) -> Void
    typealias FailureClosure = (E) -> Void
    typealias FinishClosure = (Response?, E?) -> Void
    
    enum TaskState {
        case running
        case paused
        case success(Response)
        case failure(E)
        case finished
        
        var isFinished: Bool { if case .finished = self { return true }; return false }
        var isPaused: Bool { if case .paused = self { return true }; return false }
    }
    
    private(set) var process: Process
    private(set) var success: SuccessClosure?
    private(set) var failure: FailureClosure?
    private(set) var finish: FinishClosure?
    private(set) var state: TaskState
    private(set) var afterTask: MyType?
    
    var canSuccessClosureExecutable: Bool { return success != nil || finish != nil }
    var canFailureClosureExecutable: Bool { return failure != nil || finish != nil }
    
    init(_ process: @escaping Process) {
        self.process = process
        state = .running
        doProcess()
    }
    init(paused: Bool, process: @escaping Process) {
        self.process = process
        state = paused ? .paused : .running
        doProcess()
    }
    init(fulfill response: Response) {
        self.process = { (arg) in let (fulfill, _) = arg; fulfill(response) }
        state = .running
        doProcess()
    }
    init(reject error: E) {
        self.process = { (arg) in let (_, reject) = arg; reject(error) }
        state = .running
        doProcess()
    }
    
    func resume() {
        state = .running
        doProcess()
    }
    
    @discardableResult func onSuccess(_ closure: @escaping SuccessClosure) -> MyType {
        self.success = closure
        handleByState()
        return self
    }
    
    @discardableResult func onFailure(_ closure: @escaping FailureClosure) -> MyType {
        self.failure = closure
        handleByState()
        return self
    }
    
    @discardableResult func onFinish(_ closure: @escaping FinishClosure) -> MyType {
        self.finish = closure
        handleByState()
        return self
    }
    
    @discardableResult func onThen(_ closure: @escaping Process) -> MyType {
        afterTask = MyType(paused: true, process: closure)
        return afterTask!
    }
    
    private func doProcess() {
        guard state.isPaused == false else { return }
        
        let fulfillHandler: SuccessClosure = { res in
            self.state = .success(res)
            self.handleByState()
        }
        let rejectHandler: FailureClosure = { err in
            self.state = .failure(err)
            self.handleByState()
        }
        self.process((fulfillHandler, rejectHandler))
    }
    
    private func handleByState() {
        switch state {
        case .success(let res):
            if canSuccessClosureExecutable {
                success?(res)
                finish?(res, nil)
                state = .finished
                
                afterTask?.resume()
            }
            
        case .failure(let err):
            if canFailureClosureExecutable {
                failure?(err)
                finish?(nil, err)
                state = .finished
            }
            
        default:
            break
        }
    }
}
