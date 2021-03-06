//
//  SPSwift.swift
//  SwiftProject
//
//  Created by ryan on 2020/3/8.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

typealias EventHandler = (String) -> Void
typealias SubscribeHandler = (SPObserver) -> Void


class SPObservable {

    private let subscribeHandler: SubscribeHandler

    public init(_ subscribeHandler: @escaping SubscribeHandler) {
        self.subscribeHandler = subscribeHandler
    }

    public func subscribe(eventHandler: @escaping EventHandler) {
        let observer = SPObserver(eventHandler: eventHandler)
        self.subscribeHandler(observer)
    }
}

class SPObserver {
    private let eventHandler : EventHandler
    init(eventHandler: @escaping EventHandler) {
        self.eventHandler = eventHandler
    }

    func next(value: String) {
        self.eventHandler(value)
    }
}
