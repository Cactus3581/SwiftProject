//
//  Fetcher.swift
//  SwiftProject
//
//  Created by 夏汝震 on 2022/4/2.
//  Copyright © 2022 cactus. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

// 屏蔽rust接口

enum GroupDataState {
    case idle
    case loading(Data?)
    case loaded(Data)
    case error(Error, Data?)

    enum UpdateData {
        case none,
             reloadData,
             updateParent([ParentEntity]),
             removeParent([Int]),
             updateChild([ChildEntity]),
             removeChild([Int]),
             foldParent([Int])
    }

    typealias Data = [UpdateData]
}

// Queries
extension GroupDataState {
    var data: Data? {
        switch self {
        case .idle:
            return nil
        case .loaded(let data):
            return data
        case .loading(let data),
             .error(_, let data):
            return data
        }
    }

    var isLoading: Bool {
        switch self {
        case .loading:
            return true
        case .idle, .loaded, .error:
            return false
        }
    }
}

// Commands
extension GroupDataState {
    mutating func toLoading() {
        switch self {
        case .loading:
            print("Wrong State Transition")
        case .idle, .loaded, .error:
            self = .loading(data)
        }
    }

    mutating func toLoaded(with data: Data) {
        switch self {
        case .idle, .error, .loaded:
            print("Wrong State Transition")
        case .loading:
            self = .loaded(data)
        }
    }

    mutating func toError(with error: Error) {
        switch self {
        case .idle, .error, .loaded:
            print("Wrong State Transition")
        case .loading:
            self = .error(error, data)
        }
    }

    mutating func update(_ data: Data) {
        switch self {
        case .idle:
            self = .loaded(data)
        case .loading:
            self = .loading(data)
        case .loaded:
            self = .loaded(data)
        case .error(let err, _):
            self = .error(err, data)
        }
    }
}

class Fetcher {

    // 数据状态：请求中、成功、失败、refresh、loadmore

    let dataRelay = BehaviorRelay<GroupDataState.Data>(value: [.none])

    init() {}

    func getParent() {
        var parents: [ParentEntity] = []
        for i in 0..<10 {
            let j = i + 1
            let parent = ParentEntity(id: j, position: i)
            parents.append(parent)
        }
        dataRelay.accept([.updateParent(parents)])
    }

    func getChild() {
        var childs: [ChildEntity] = []
        for i in 0..<10 {
            let j = i + 1
            let a = ParentItem(parentId: j, position: i)
            let child = ChildEntity(parentItems: [j:a], id: j)
            childs.append(child)
        }
        dataRelay.accept([.updateChild(childs)])
    }
}
