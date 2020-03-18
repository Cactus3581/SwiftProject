//
//  MVVMListSecCellViewModel.swift
//  SwiftProject
//
//  Created by 夏汝震 on 2020/3/12.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

//MARK:在一个session中存在多种cell，需要使用cellVMProtocol
// 因为identifier可以由sessionVM提供，生成数据的方式不需要统一成一个接口，因为sessionVM已经确定了单个的scellVM的方式。如果sessionVM里面会有多种类型，那么必须提供CellVMProtocol
protocol MVVMListSecCellViewModelProtocol {

    // 如果默认session只有一种类型
    init(itemData: Any) // 因为已经确认只有一种类型，所以也是可以明确的创建方法
    var identifier: String { get } //可以省略掉，放到sessionViewModelProtocol里

    // 因为一种vm对应一种cell，所以不需要统一的接口来提供数据和事件
}

extension MVVMListSecCellViewModelProtocol {

    init(itemData: Any) {
        self.init(itemData: itemData)
    }

    var identifier: String {
       return ""
    }
}

//MARK:多种cellVM对应同一个cell，使用协议的方式
protocol MVVMListCourseCellViewModelProtocol {
    var title: String? { get }
}

extension MVVMListCourseCellViewModelProtocol {
    var title: String? {
       return ""
    }
}

class MVVMListListeningCellViewModel: NSObject {

    var model: MVVMListListeningModel?

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

class MVVMListSpeakCellViewModel: MVVMListCourseCellViewModelProtocol {

    var model: MVVMListSpeakItemModel?

    var title: String? {
        return model?.speakScore
    }

    var identifier: String {
        return MVVMListCourseTableViewCell.identifier
    }
}

class MVVMListCourseCellViewModel: MVVMListCourseCellViewModelProtocol {

    var model: MVVMListCourseItemModel?
    
    var title: String? {
        return model?.courseName
    }

    var identifier: String {
        return MVVMListCourseTableViewCell.identifier
    }
}
