//
//  ViewDataState.swift
//  SwiftProject
//
//  Created by 夏汝震 on 2022/4/12.
//  Copyright © 2022 cactus. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

/** ViewDataState的设计：将data数据转化为可被ui理解的数据
1. 监听dataSource的数据回调，将数据处理成UI数据
2. 记录跟UI相关的数据状态，比如选中、展开收起
3. 面向UI，提供数据接口
*/

class ViewDataState {
    enum State {
        case loading,
             loaded,
             empty
    }

    enum Render {
        case none,
             fullReload,
             reloadSection(Int)
    }

    private let data: DataSource
    private var selectedId: Int? // 选中状态
    private var expandMap: [Int:Bool] = [:]  // 展开收起状态
    private var loadingMap: [Int:Bool] = [:]

    private let renderRelay: BehaviorRelay<GroupDataState.ExtraInfo>
    var renderObservable: Observable<GroupDataState.ExtraInfo> {
        return renderRelay.asObservable()
    }

    private let stateRelay: BehaviorRelay<ViewDataState.State>
    var stateObservable: Observable<ViewDataState.State> {
        return stateRelay.asObservable()
    }
    var state: ViewDataState.State {
        return stateRelay.value
    }

    private let disposeBag: DisposeBag

    init(data: DataSource) {
        self.data = data
        self.disposeBag = DisposeBag()
        self.stateRelay = BehaviorRelay<ViewDataState.State>(value: .loading)
        // TODO: 是否需要使用Relay？默认值问题
        self.renderRelay = BehaviorRelay<GroupDataState.ExtraInfo>(value: GroupDataState.ExtraInfo.default())
        setup()
    }

    private func setup() {
        data.dataObservable
            .subscribe(onNext: { [weak self] storeInfo in
                self?.renderRelay.accept(storeInfo.extraInfo)
        }).disposed(by: disposeBag)

        data.fetcher.stateObservable
            .subscribe(onNext: { [weak self] state in
                let viewDataState: ViewDataState.State
                switch state {
                case .idle:
                    viewDataState = .loading
                case .loading:
                    viewDataState = .loading
                case .loaded:
                    viewDataState = .loaded
                case .error:
                    viewDataState = .empty
                }
                self?.stateRelay.accept(viewDataState)
        }).disposed(by: disposeBag)
    }
}

// MARK: UI刷新完成
extension ViewDataState {
    // TODO: loadingMap的读取不在一处；遇到getError时，并不会完成闭环
    func renderFinish(dataFrom: GroupDataState.DataFrom) {
        switch dataFrom {
        case .none: break
        case .loadMoreChild(let parentId):
            loadingMap[parentId] = false
        }
    }
}

// MARK: 对外提供UI数据
extension ViewDataState {
    var sectionCount: Int {
        return data.store.indexData.count
    }

    func count(in section: Int) -> Int {
        return data.store.indexData.getIndexData(index: section)?.count ?? 0
    }

    func getChildEntity(indexPath: IndexPath) -> ChildEntity? {
        return data.store.getChildEntity(indexPath: indexPath)
    }

    func getParentEntity(section: Int) -> ParentEntity? {
        return data.store.getParentEntity(index: section)
    }
}

// MARK: 设置item的选中状态
extension ViewDataState {
    func updateSelectedId(_ id: Int) {
        assert(Thread.isMainThread, "dataSource is only available on main thread")
        self.selectedId = id
    }

    func getSelectedId() -> Int? {
        assert(Thread.isMainThread, "dataSource is only available on main thread")
        return selectedId
    }
}

// MARK: 设置展开收起状态
extension ViewDataState {
    func updateExpandState(id: Int, isExpand: Bool) {
        assert(Thread.isMainThread, "dataSource is only available on main thread")
        self.expandMap[id] = isExpand
    }

    func toggleExpandState(id: Int) {
        var a = true
        a.toggle()
        if let expand = getExpandState(id: id), expand {
            updateExpandState(id: id, isExpand: false)
        } else {
            updateExpandState(id: id, isExpand: true)
        }
    }

    func getExpandState(id: Int) -> Bool? {
        assert(Thread.isMainThread, "dataSource is only available on main thread")
        return self.expandMap[id]
    }
}

// MARK: 分页触发
extension ViewDataState {
    func loadChild(sectionId: Int, index: Int) {
        // TODO: loadMore机制待优化
        let loading = loadingMap[sectionId] ?? false
//        let buffer = 15
//        let ready = index >= (self.data.store.indexData.count - buffer)
        let ready = true // 这个字段暂时用不到
        guard let parentIndexData = self.data.store.indexData.getIndexData(id: sectionId) else { return }
        let hasMore = parentIndexData.hasMore ?? true
        let result = ready && (!loading) && hasMore
//        print("loadChild-result: \(result), index: \(index), loading: \(loading), ready: \(ready), hasMore: \(hasMore)")
        guard result else { return }
        print("loadChild-result: \(result), index: \(index), loading: \(loading), ready: \(ready), hasMore: \(hasMore)")
        loadingMap[sectionId] = true
        self.data.fetcher.loadMoreChild(sectionId: sectionId)
            .asObservable()
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { _ in
        }, onError: { [weak self] _ in
            self?.loadingMap[sectionId] = false
        }).disposed(by: disposeBag)
    }
}
