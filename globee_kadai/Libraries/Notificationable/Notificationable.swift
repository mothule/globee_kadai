//
//  Notificationable.swift
//  
//
//  Created by motoki kawakami on 2020/07/09.
//  Copyright © 2020 mothule. All rights reserved.
//

import Foundation

protocol Notificationable {
    var noticeName: String { get }
    var noticeUserInfo: [AnyHashable: Any]? { get }
}

extension Notificationable {
    var name: Notification.Name { .init(noticeName) }
    var noticeUserInfo: [AnyHashable: Any]? { nil }
    
    func addObserver(_ observer: Any, selector: Selector, object: Any? = nil) {
        NotificationCenter.default.addObserver(observer, selector: selector, name: name, object: object)
    }
    
    func post(object: Any? = nil) {
        NotificationCenter.default.post(makeNotification(object: object))
    }
    
    func makeNotification(object: Any? = nil) -> Notification {
        .init(name: name, object: object, userInfo: noticeUserInfo)
    }
}

extension Error {
    var toDictionary: [AnyHashable: Error] { ["error": self] }
}
