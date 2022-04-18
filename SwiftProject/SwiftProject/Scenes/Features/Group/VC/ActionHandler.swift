//
//  ActionHandler.swift
//  SwiftProject
//
//  Created by 夏汝震 on 2022/4/12.
//  Copyright © 2022 cactus. All rights reserved.
//

import Foundation

/** ActionHandler的设计：分担VC的事件处理工作
 1. 从事件转发到vc，转向到ActionHandler
 2. 缺点：应该由各个subModule来处理，这个类不应该存在
*/

class ActionHandler {

    let vm: GroupVM

    init(vm: GroupVM) {
        self.vm = vm
    }

    func expand(entity: ParentEntity, section: Int) {
        vm.viewDataState.toggleExpandState(id: entity.id)
        let info = GroupDataState.ExtraInfo(render: .reloadSection(section), dataFrom: .none)
        vm.data.trigger(info: info)
    }
}
