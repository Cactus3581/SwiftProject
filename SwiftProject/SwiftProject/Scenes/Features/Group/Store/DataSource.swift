//
//  DataSource.swift
//  SwiftProject
//
//  Created by 夏汝震 on 2022/4/12.
//  Copyright © 2022 cactus. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

/** DataSource的设计：作为整个功能的数据提供方，管理协调fetcher、queue、store等角色
1. 使用fetcher调用api接口，并监听fetcherOB获取数据
2. 将数据处理放到queue里执行
3. 使用store提供的接口进行数据存储
*/

final class DataSource {

    let fetcher = Fetcher()
    private let dataQueue = DataQueue()
    private var _store: DataStoreInterface // 只在queue里使用
    var store: DataStoreInterface {
        return dataRelay.value.store
    }
    private let dataRelay: BehaviorRelay<GroupDataState.StoreInfo>
    var dataObservable: Observable<GroupDataState.StoreInfo> {
        return dataRelay.asObservable()
    }
    private let disposeBag: DisposeBag

    init() {
        self.disposeBag = DisposeBag()
        let store = DataStore()
        self._store = store
        let info = GroupDataState.StoreInfo(store: store, extraInfo: GroupDataState.ExtraInfo.default())
        self.dataRelay = BehaviorRelay<GroupDataState.StoreInfo>(value: info)
        setup()
    }

    private func setup() {
        fetcher.dataObservable
            .subscribe(onNext: { [weak self] data in
            self?.updateData(data)
        }).disposed(by: disposeBag)
    }

    func updateData(_ data: GroupDataState.DataInfo) {
        let task = { [weak self] in
            guard let self = self else { return }
            let canUpdate = self._handleData(data.data)
            guard canUpdate else { return }
            self.fireRefresh(self._store, extraInfo: data.extraInfo)
        }
        self.dataQueue.addTask(task)
    }

    func trigger(info: GroupDataState.ExtraInfo) {
        let task = { [weak self] in
            guard let self = self else { return }
            self.fireRefresh(self._store, extraInfo: info)
        }
        self.dataQueue.addTask(task)
    }

    private func _handleData(_ datas: [GroupDataState.UpdatedData]) -> Bool {
        // TODO: 减少数据更新，减少UI刷新次数
        let canUpdate = true
        datas.forEach({ data in
            switch data {
            case .updateParentByGet(let response):
                self._store.updateParentsHasMore(response.hasMore)
                self._store.update(parents: response.updateParent)
                break
            case .updateChildByGet(let response):
                self._store.updateChildsHasMore(response.hasMore, parentId: response.parentId)
                self._store.update(childs: response.updateChild)
                break
            case .updateParent(let parentEntitys):
                self._store.update(parents: parentEntitys)
                break

            case .removeParent(let parentIds):
                self._store.remove(parentIds: parentIds)
                break

            case .updateChild(let childEntitys):
                self._store.update(childs: childEntitys)
                break

            case .removeChild(let childIds):
                self._store.remove(childs: childIds)
                break
            }
        })
        return canUpdate
    }
    
    private func fireRefresh(_ store: DataStoreInterface, extraInfo: GroupDataState.ExtraInfo) {
        DispatchQueue.main.async { [store, weak self] in
            guard let self = self else { return }
            let info = GroupDataState.StoreInfo(store: store, extraInfo: extraInfo)
            self.dataRelay.accept(info)
        }
    }
}
