//
//  GroupVM.swift
//  SwiftProject
//
//  Created by 夏汝震 on 2022/4/2.
//  Copyright © 2022 cactus. All rights reserved.
//

import RxSwift
import RxCocoa

final class GroupVM {

    private var _dataSource: GroupDataSource
    var dataSource: GroupDataSourceInterface {
        return _dataSource
    }

    let fetcher = Fetcher()
    let dataQueue = DataQueue()

    let dataRelay: BehaviorRelay<GroupDataSourceInterface>
    let disposeBag: DisposeBag

    enum UpdateData {
        case none,
             waiting,
             fetching,
             success(GroupDataSourceInterface),
             error
    }

    init() {
        self.disposeBag = DisposeBag()
        let _dataSource = GroupDataSource()
        self._dataSource = _dataSource
        self.dataRelay = BehaviorRelay<GroupDataSourceInterface>(value: _dataSource)
        setup()
    }

    func setup() {
        fetcher.dataRelay.subscribe(onNext: { [weak self] data in
            let task = { [weak self] in
                guard let self = self else { return }
                self.handlaData(data)
                self.fireRefresh(self._dataSource)
            }
            self?.dataQueue.addTask(task)
        }).disposed(by: disposeBag)
        fetcher.getParent()
        fetcher.getChild()
    }

    func handlaData(_ datas: GroupDataState.Data) {
        var isNeedUIReRender = true
        datas.forEach({ data in
            switch data {
            case .none:
                isNeedUIReRender = false
                break
            case .reloadData:
                break
            case .updateParent(let parentEntitys):
                self._dataSource.update(parents: parentEntitys)
                break

            case .removeParent(let parentIds):
                self._dataSource.remove(parentIds: parentIds)
                break

            case .updateChild(let childEntitys):
                self._dataSource.update(childs: childEntitys)
                break

            case .removeChild(let childIds):
                break

            case .foldParent(let parentIds):
                break
            }
        })
    }

    private func fireRefresh(_ data: GroupDataSourceInterface) {
        DispatchQueue.main.async { [data, weak self] in
            guard let self = self else { return }
            self.dataRelay.accept(data)
        }
    }
}
