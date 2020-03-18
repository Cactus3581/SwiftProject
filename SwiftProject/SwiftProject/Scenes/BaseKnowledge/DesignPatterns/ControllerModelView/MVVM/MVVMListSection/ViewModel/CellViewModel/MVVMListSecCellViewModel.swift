//
//  MVVMListSecCellViewModel.swift
//  SwiftProject
//
//  Created by 夏汝震 on 2020/3/12.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

//MARK:如果在每个session的cell都一致的情况下，没有必要使用cellVMProtocol
// 因为identifier可以由sessionVM提供，生成数据的方式不需要统一成一个接口，因为sessionVM已经确定了单个的scellVM的方式。如果sessionVM里面会有多种类型，那么必须提供CellVMProtocol
protocol MVVMListSecCellViewModelProtocol {

    // 如果默认session只有一种类型
    static func canHandle(type: String) -> Bool
    init(data: Any) // 因为已经确认只有一种类型，所以也是可以明确的创建方法
    var identifier: String { get } //可以省略掉，放到sessionViewModelProtocol里

    // 因为一种vm对应一种cell，所以不需要统一的接口来提供数据和事件
}

extension MVVMListSecCellViewModelProtocol {

    static func canHandle(type: String) -> Bool {
        return false
    }

    init(data: Any) {
        self.init(data: data)
    }

    var identifier: String {
       return ""
    }
}

class MVVMListListeningCellViewModel: MVVMListSecCellViewModelProtocol {

    var model: MVVMListListeningModel?

    static func canHandle(type: String) -> Bool {
        if type == "button" {
            return true
        }
        return false
    }

    required init(data: Any) {
        let model = data as? MVVMListSecModel
        self.model = model?.listening
    }

    var identifier: String {
        return MVVMListListeningTableViewCell.identifier
    }

    func jump() {
        // 通过路由
        print("事件：跳转")
    }

    func click() {
        // 具体事件具体分析
        print("事件：点击")
    }

    func updateData(result: ((MVVMListListeningCellViewModel) -> ())) {
        // 数据更新
        result(self)
    }
}

class MVVMListCourseCellViewModel: MVVMListSecCellViewModelProtocol {

    var model: MVVMListCourseItemModel?

    static func canHandle(type: String) -> Bool {
        if type == "label" {
            return true
        }
        return false
    }

    required init(data: Any) {
        model = data as? MVVMListCourseItemModel
    }

    var identifier: String {
        return MVVMListCourseTableViewCell.identifier
    }
}
