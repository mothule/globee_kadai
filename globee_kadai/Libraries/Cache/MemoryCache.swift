//
//  MemoryCache.swift
//  
//
//  Created by motoki kawakami on 2020/07/09.
//  Copyright © 2020 mothule. All rights reserved.
//

import Foundation

/**
 ## キャッシュオブジェクト
 
 - warning:
    - 複数箇所で同一キーのキャッシュ宣言は避けてください.
    - 宣言元で期限時間が変えられるため、想定外の難解な不具合を生む原因となります。
 */
struct Cache<T> {
    private let key: String
    private let expireTime: TimeInterval?
    
    init(key: String, expireTime: TimeInterval? = nil) {
        self.key = key
        self.expireTime = expireTime
        MemoryCache.shared.set(key: key, expireTime: expireTime)
    }
    
    var value: T? {
        get {
            return MemoryCache.shared.get(key: key)
        }
        set {
            MemoryCache.shared.set(key: key, value: newValue, expireTime: expireTime)
        }
    }
    
    func invalidate() {
        MemoryCache.shared.invalidate(key: key)
    }
}

class MemoryCache {
    static var shared: MemoryCache = MemoryCache()
    
    private var cachedObjects: [AnyHashable: MemoryCachedObject] = [:]
    var cachedObjectsCount: Int { cachedObjects.count }
    
    func get<T>(key: AnyHashable) -> T? {
        guard let object = cachedObjects[key] else { return nil }
        return object.get()
    }
    
    func set<T>(key: AnyHashable, value: T?, expireTime: TimeInterval? = nil) {
        if cachedObjects[key] != nil {
            cachedObjects[key]?.set(value, expireTime: expireTime)
        } else {
            cachedObjects[key] = MemoryCachedObject(value: value, expireTime: expireTime)
        }
    }
    
    func set(key: AnyHashable, expireTime: TimeInterval? = nil) {
        if cachedObjects[key] != nil {
            cachedObjects[key]?.set(expireTime: expireTime)
        } else {
            cachedObjects[key] = MemoryCachedObject(expireTime: expireTime)
        }
    }
    
    func dump() -> String {
        var result = ""
        cachedObjects.forEach({
            result += "{\($0.key): \($0.value)}\n"
        })
        return result
    }
    
    func invalidate(key: AnyHashable) {
        cachedObjects[key]?.invalidate()
    }
    
    func clearAll() {
        cachedObjects.removeAll(keepingCapacity: false)
    }
}

private class MemoryCachedObject {
    private var target: Any? {
        didSet {
            updatedAt = Date()
        }
    }
    private var value: Any? {
        set {
            target = newValue
        }
        get {
            return isExpired ? nil : target
        }
    }
    private var updatedAt: Date = Date()
    private var expireTime: TimeInterval?
    
    init(value: Any?, expireTime: TimeInterval? = nil) {
        self.value = value
        self.expireTime = expireTime
    }
    init(expireTime: TimeInterval? = nil) {
        self.expireTime = expireTime
        expire()
    }

    private var expireDate: Date? {
        guard let expireTime = expireTime else { return nil }
        return updatedAt.addingTimeInterval(expireTime)
    }
    
    private var isExpired: Bool {
        guard let expireDate = expireDate else { return false }
        return Date() > expireDate
    }
    
    private func expire() {
        guard let expireTime = expireTime else { return }
        updatedAt = Date().addingTimeInterval(-expireTime)
    }
    
    func invalidate() {
        value = nil
        expire()
    }
    
    func get<T>() -> T? {
        return value as? T
    }
    
    func set(_ value: Any?, expireTime: TimeInterval? = nil) {
        self.value = value
        self.expireTime = expireTime
    }
    func set(expireTime: TimeInterval? = nil) {
        self.expireTime = expireTime
    }
}

extension MemoryCachedObject: CustomDebugStringConvertible {
    var debugDescription: String {
        let valueString = "\(value != nil ? value! : "nil")"
        let targetString = "\(target != nil ? target! : "nil")"
        let expireTimeString = "\(expireTime != nil ? "\(expireTime!)" : "infinity")"
        return "{value: \(valueString), target: \(targetString) updatedAt: \(updatedAt), expireTime: \(expireTimeString)}"
    }
}
