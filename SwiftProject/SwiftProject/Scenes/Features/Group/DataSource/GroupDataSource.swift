//
//  GroupDataSource.swift
//  SwiftProject
//
//  Created by 夏汝震 on 2022/4/2.
//  Copyright © 2022 cactus. All rights reserved.
//


// 可解耦：实体更新和列表尽量解耦，减少一级列表和二级列表的关联关系
// 可减少丢数据
// 减少 更新数据 及 refresh 次数

import Foundation

// id和实体的维护关系：字典，id和entity
// 列表和实体的关系：字典，id和index
// models：数组，通过index可以获取到entity

protocol GroupDataSourceInterface {
    var indexData: IndexDataInterface { get }

    // 一级列表
    mutating func update(parents: [ParentEntity])
    mutating func remove(parentIds: [Int])
    func getParentEntity(id: Int) -> ParentEntity?
    func getParentEntity(index: Int) -> ParentEntity?

    // 二级列表
    mutating func update(childs: [ChildEntity])
    mutating func remove(childs: [IndexDataBaseInterface])
    func getChildEntity(id: Int) -> ChildEntity?
    func getChildEntity(indexData: IndexDataInterface) -> ChildEntity?
    func getChildEntity(indexPath: IndexPath) -> ChildEntity?
}

struct GroupDataSource: GroupDataSourceInterface {
    // id: Entity
    private var parentEntityMap: [Int:ParentEntity] = [:]
    private var childEntityMap: [Int:ChildEntity] = [:]

    // 列表关系
    var indexData: IndexDataInterface {
        return _indexData
    }
    private let _indexData = IndexData.default()
    init() {}

    // 一级列表
    mutating func update(parents: [ParentEntity]) {
        parents.forEach({ parent in
            let parentId = parent.id
            self.parentEntityMap[parentId] = parent
            self._indexData.update(childId: parentId, originOrder: parent.position)
        })
        self._indexData.sort()
    }

    mutating func remove(parentIds: [Int]) {
        parentIds.forEach({ parentId in
            remove(parentId: parentId)
        })
        self._indexData.sort()
    }

    private mutating func remove(parentId: Int) {
        guard getParentEntity(id: parentId) != nil else { return }
        self.parentEntityMap.removeValue(forKey: parentId)
        self._indexData.remove(id: parentId)
    }

    func getParentEntity(id: Int) -> ParentEntity? {
        return self.parentEntityMap[id]
    }

    func getParentEntity(index: Int) -> ParentEntity? {
        guard let indexData = self._indexData.getIndexData(index: index) else { return nil }
        return getParentEntity(id: indexData.id)
    }

    // 二级列表
    mutating func update(childs: [ChildEntity]) {
        var needSortData: Set<IndexData> = []
        childs.forEach({ child in
            let childId = child.id
            // 更新child实体
            self.childEntityMap[childId] = child
            child.parentItems.forEach({ parentId, parentItem in
                // 更新列表关系：向列表中插入indexData
                guard let parentIndexData = self._indexData.getIndexData(id: parentId) as? IndexData else { return }
                parentIndexData.update(childId: childId, originOrder: parentItem.position)
                needSortData.insert(parentIndexData)
            })
        })

        // 更新列表排序
        needSortData.forEach({ parentIndexData in
            parentIndexData.sort()
        })
    }

    mutating func remove(childs: [IndexDataBaseInterface]) {
        var needSortData: Set<IndexData> = []
        childs.forEach({ child in
            guard let parent = self._indexData.getIndexData(id: child.parentId) as? IndexData else { return }
            needSortData.insert(parent)
            parent.remove(id: child.id)
        })
        // 更新列表排序
        needSortData.forEach({ parentIndexData in
            parentIndexData.sort()
        })
    }

    func getChildEntity(indexData: IndexDataInterface) -> ChildEntity? {
        return self.childEntityMap[indexData.id]
    }

    func getChildEntity(id: Int) -> ChildEntity? {
        return self.childEntityMap[id]
    }

    func getChildEntity(indexPath: IndexPath) -> ChildEntity? {
        guard let id = self._indexData.getIndexData(index: indexPath.section)?.getIndexData(index: indexPath.row)?.id else { return nil }
        return self.childEntityMap[id]
    }
}
