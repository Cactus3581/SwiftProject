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

/** Fetcher的设计：屏蔽api接口，组装各种发送请求到server中
1. 不保存任何状态
2. 数据暂时不作简单处理，直接返回response，后期看是否优化成updateDatas、removeDatas
3. 增加数据状态：可通过使用枚举的方式，比如 idle、 loading、load、error
*/

class Fetcher {

    private let dataSubject = PublishSubject<GroupDataState.DataInfo>()
    var dataObservable: Observable<GroupDataState.DataInfo> {
        return dataSubject.asObservable()
    }

    private let stateSubject = PublishSubject<GroupDataState.DataState>()
    var stateObservable: Observable<GroupDataState.DataState> {
        return stateSubject.asObservable()
    }

    init() {}

    func refresh() {
        getParent()
    }

    private func getParent() {
        stateSubject.onNext(.loading)
        var parents: [ParentEntity] = []
        for i in 0..<100 {
            let item = EntityItem(id: i, parentId: 0, position: i)
            let p = ParentEntity(id: i, item: item)
            parents.append(p)
        }
        let response = GroupDataState.GetParents(updateParent: parents, hasMore: true)
        let extraInfo = GroupDataState.ExtraInfo(render: .fullReload, dataFrom: .none)
        let info = GroupDataState.DataInfo(data: [.updateParentByGet(response)],
                                                extraInfo: extraInfo)
        stateSubject.onNext(.loaded)
        dataSubject.onNext(info)
    }

    func loadMoreChild(sectionId: Int) -> Observable<Bool> {
        var childs: [ChildEntity] = []
        for i in 0 ..< 10 {
            let item = EntityItem(id: i, parentId: sectionId, position: i)
            let c = ChildEntity(id: i, item: item)
            childs.append(c)
        }
        let response = GroupDataState.GetChilds(parentId: sectionId, updateChild: childs, hasMore: false)
        let extraInfo = GroupDataState.ExtraInfo(render: .fullReload, dataFrom: .loadMoreChild(sectionId))
        let info = GroupDataState.DataInfo(data: [.updateChildByGet(response)],
                                                extraInfo: extraInfo)
        dataSubject.onNext(info)
        return .just(true)
    }
}
