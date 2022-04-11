//
//  Index.swift
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
    func update(childId: Int, originOrder: Int)
    func remove(id: Int)
    func remove(index: Int)
    func getIndexData(id: Int) -> IndexDataInterface?
    func getIndexData(index: Int) -> IndexDataInterface?
}

class IndexData: Hashable, IndexDataInterface {
    let id: Int
    let parentId: Int
    private let originOrder: Int
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

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func update(childId: Int, originOrder: Int) {
        if let index = self.childIndexMap[childId] {
            let indexData = IndexData(id: childId, parentId: parentId, originOrder: originOrder)
            self.childIndexList.replaceSubrange(index..<(index + 1), with: [indexData])
        } else {
            let indexData = IndexData(id: childId, parentId: parentId, originOrder: originOrder)
            self.childIndexList.append(indexData)
        }
    }

    func remove(id: Int) {
        guard let index = self.childIndexMap[id] else { return }
        remove(index: index)
    }

    func remove(index: Int) {
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

    func sort() {
        self.childIndexList = self.childIndexList.sorted(by: { $0.originOrder > $1.originOrder })
        self.childIndexMap.removeAll()
        for i in 0..<childIndexList.count {
            let child = childIndexList[i]
            self.childIndexMap[child.id] = i
        }
    }

    static func == (lhs: IndexData, rhs: IndexData) -> Bool {
        return lhs === rhs
    }
    
    func hash(into hasher: inout Hasher) {
        ObjectIdentifier(self).hash(into: &hasher)
    }
}
