//
//  GroupVM.swift
//  SwiftProject
//
//  Created by 夏汝震 on 2022/4/2.
//  Copyright © 2022 cactus. All rights reserved.
//

import RxSwift
import RxCocoa

/** GroupVM的设计：面向VC，管理dataSource、ViewDataState
 1. 管理并协调其下面的各个角色
 2. 不做具体的工作，具体工作由它管理的各个角色来实现
*/

final class GroupVM {

    let data: DataSource
    let viewDataState: ViewDataState
    private let disposeBag: DisposeBag

    init() {
        self.disposeBag = DisposeBag()
        let data = DataSource()
        self.data = data
        self.viewDataState = ViewDataState(data: data)
        setup()
    }

    private func setup() {
        data.fetcher.refresh()
    }
}
