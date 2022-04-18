//
//  GroupDataState.swift
//  SwiftProject
//
//  Created by 夏汝震 on 2022/4/18.
//  Copyright © 2022 cactus. All rights reserved.
//

import Foundation

enum GroupDataState {

    /** TODO:  数据状态、view状态
     1. 暂时将state和数据分开，预期是将数据挂到state（枚举）上：Loading、空态
     2. 暂时描述的是整体的数据状态，并没有细致到描述每个子列表的数据状态
     */
    enum DataState {
        case idle,
             loading,
             loaded,
             error
    }

    case idle
    case loading(StoreInfo?)
    case loaded(StoreInfo)
    case error(Error, StoreInfo?)

    enum DataFrom {
        case none,
             loadMoreChild(Int)
    }

    struct ExtraInfo {
        public static func `default`() -> ExtraInfo {
            return GroupDataState.ExtraInfo(render: .none, dataFrom: .none)
        }
        let render: ViewDataState.Render
        let dataFrom: DataFrom
        init(render: ViewDataState.Render,
             dataFrom: DataFrom) {
            self.render = render
            self.dataFrom = dataFrom
        }
    }

    struct DataInfo {
        let data: [UpdatedData]
        let extraInfo: ExtraInfo

        init(data: [UpdatedData],
             extraInfo: ExtraInfo) {
            self.data = data
            self.extraInfo = extraInfo
        }
    }

    struct StoreInfo {
        let store: DataStoreInterface
        let extraInfo: ExtraInfo

        init(store: DataStoreInterface,
             extraInfo: ExtraInfo) {
            self.store = store
            self.extraInfo = extraInfo
        }
    }

    enum UpdatedData {
        case updateParentByGet(GetParents),
             updateChildByGet(GetChilds),
             updateParent([ParentEntity]),
             removeParent([Int]),
             updateChild([ChildEntity]),
             removeChild([IndexDataBaseInterface])
    }

    struct GetParents {
        let updateParent: [ParentEntity]
        let hasMore: Bool

        init(updateParent: [ParentEntity], hasMore: Bool) {
            self.updateParent = updateParent
            self.hasMore = hasMore
        }
    }

    struct GetChilds {
        let parentId: Int
        let updateChild: [ChildEntity]
        let hasMore: Bool

        init(parentId: Int, updateChild: [ChildEntity], hasMore: Bool) {
            self.parentId = parentId
            self.updateChild = updateChild
            self.hasMore = hasMore
        }
    }
}

// Queries
extension GroupDataState {
    var data: StoreInfo? {
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

    mutating func toLoaded(with data: StoreInfo) {
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

    mutating func update(_ data: StoreInfo) {
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
