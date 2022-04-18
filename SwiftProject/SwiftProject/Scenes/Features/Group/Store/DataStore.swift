//
//  DataStore.swift
//  SwiftProject
//
//  Created by 夏汝震 on 2022/4/2.
//  Copyright © 2022 cactus. All rights reserved.
//

import Foundation

/** DataStore的设计：存储实体
 1. 实体和列表关系分开维护
    1.1 可解耦：实体更新和列表尽量解耦，减少一级列表和二级列表的关联关系
    1.2 可减少丢数据
    1.3 减少 更新数据 及 refresh 次
 2. 实体使用map，列表关系使用indexData
 3. 接口为纯粹的增删改查
 */

protocol DataStoreInterface {
    var indexData: IndexDataInterface { get }

    // 一级列表
    mutating func update(parents: [ParentEntity])
    mutating func remove(parentIds: [Int])
    mutating func updateParentsHasMore(_ hasMore: Bool)
    func getParentEntity(id: Int) -> ParentEntity?
    func getParentEntity(index: Int) -> ParentEntity?

    // 二级列表
    mutating func update(childs: [ChildEntity])
    mutating func remove(childs: [IndexDataBaseInterface])
    mutating func updateChildsHasMore(_ hasMore: Bool, parentId: Int)
    func getChildEntity(id: Int) -> ChildEntity?
    func getChildEntity(indexData: IndexDataInterface) -> ChildEntity?
    func getChildEntity(indexPath: IndexPath) -> ChildEntity?
}

struct DataStore: DataStoreInterface {
    // id: Entity
    private var parentEntityMap: [Int:ParentEntity] = [:]
    private var childEntityMap: [Int:ChildEntity] = [:]

    // 列表关系
    var indexData: IndexDataInterface {
        return _indexData
    }
    private var _indexData = IndexData.default()
    init() {}

    // 一级列表
    func canUpdate() -> Bool {
        return true
    }

    func canDelete() -> Bool {
        return true
    }

    func canSort() -> Bool {
        return true
    }

    func canPage() -> Bool {
        return true // 是否可以分页
    }

    mutating func update(parents: [ParentEntity]) {
        parents.forEach({ parent in
            let parentId = parent.id
            self.parentEntityMap[parentId] = parent
            self._indexData.update(childId: parentId, originOrder: parent.item.position)
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

    mutating func updateParentsHasMore(_ hasMore: Bool) {
        self._indexData.hasMore = hasMore
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
        var needSortData: Set<Int> = []
        childs.forEach({ child in
            let childId = child.id
            // 更新child实体
            self.childEntityMap[childId] = child
            // 更新列表关系：向列表中插入indexData
            guard var parent = self._indexData.getIndexData(id: child.item.parentId) as? IndexData else { return }
            parent.update(childId: childId, originOrder: child.item.position)
            self._indexData.update(childIndexData: parent)
            needSortData.insert(parent.id)
        })

        // 更新列表排序
        needSortData.forEach({ id in
            guard var parent = self._indexData.getIndexData(id: id) as? IndexData else { return }
            parent.sort()
            self._indexData.update(childIndexData: parent)
        })
    }

    mutating func remove(childs: [IndexDataBaseInterface]) {
        var needSortData: Set<Int> = []
        childs.forEach({ child in
            guard var parent = self._indexData.getIndexData(id: child.parentId) as? IndexData else { return }
            parent.remove(id: child.id)
            self._indexData.update(childIndexData: parent)
            needSortData.insert(parent.id)
        })
        // 更新列表排序
        needSortData.forEach({ id in
            guard var parent = self._indexData.getIndexData(id: id) as? IndexData else { return }
            parent.sort()
            self._indexData.update(childIndexData: parent)
        })
    }

    mutating func updateChildsHasMore(_ hasMore: Bool, parentId: Int) {
        guard var indexData = self._indexData.getIndexData(id: parentId) as? IndexData else { return }
        indexData.hasMore = hasMore
        self._indexData.update(childIndexData: indexData)
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
