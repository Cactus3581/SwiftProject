//
//  IndexData.swift
//  SwiftProject
//
//  Created by 夏汝震 on 2022/4/2.
//  Copyright © 2022 cactus. All rights reserved.
//

import Foundation

protocol IndexDataBaseInterface {
    var id: Int { get }
    var parentId: Int { get }
}

protocol IndexDataInterface: IndexDataBaseInterface {
    var count: Int { get }
    var hasMore: Bool? { set get }
    mutating func update(childId: Int, originOrder: Int)
    mutating func update(childIndexData: IndexData)
    mutating func remove(id: Int)
    mutating func remove(index: Int)
    func getIndexData(id: Int) -> IndexDataInterface?
    func getIndexData(index: Int) -> IndexDataInterface?
}

struct IndexData: Hashable, IndexDataInterface {
    let id: Int
    let parentId: Int
    private let originOrder: Int
    // TODO: hasMore的默认值应该是true还是false
    var hasMore: Bool?
    // 顺序关系
    private var childIndexList: [IndexData] = []
    // 辅助查询：key: id, value: IndexData的index
    private var childIndexMap: [Int:Int] = [:]

    var count: Int {
        childIndexList.count
    }

    init(id: Int, parentId: Int, originOrder: Int) {
        self.id = id
        self.parentId = parentId
        self.originOrder = originOrder
    }

    public static func `default`() -> IndexData {
        return IndexData(id: 0, parentId: 0, originOrder: 0)
    }

    mutating func update(childId: Int, originOrder: Int) {
        let indexData = IndexData(id: childId, parentId: parentId, originOrder: originOrder)
        update(childIndexData: indexData)
    }

    mutating func update(childIndexData: IndexData) {
        if let index = self.childIndexMap[childIndexData.id] {
            self.childIndexList.replaceSubrange(index..<(index + 1), with: [childIndexData])
        } else {
            self.childIndexList.append(childIndexData)
        }
    }

    mutating func remove(id: Int) {
        guard let index = self.childIndexMap[id] else { return }
        remove(index: index)
    }

    mutating func remove(index: Int) {
        guard index < self.childIndexList.count else { return }
        self.childIndexList.remove(at: index)
    }

    func getIndexData(id: Int) -> IndexDataInterface? {
        guard let index = self.getIndex(id: id) else { return nil }
        return self.getIndexData(index: index)
    }

    func getIndexData(index: Int) -> IndexDataInterface? {
        guard index < self.childIndexList.count else { return nil }
        return self.childIndexList[index]
    }

    func getIndex(id: Int) -> Int? {
        return self.childIndexMap[id]
    }

    mutating func sort() {
        self.childIndexList = self.childIndexList.sorted(by: { $0.originOrder > $1.originOrder })
        self.childIndexMap.removeAll()
        for i in 0..<childIndexList.count {
            let child = childIndexList[i]
            self.childIndexMap[child.id] = i
        }
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: IndexData, rhs: IndexData) -> Bool {
        return lhs.id == rhs.id
    }
}
