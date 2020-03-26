//
//  MVVMListSecCellViewModel.swift
//  SwiftProject
//
//  Created by ryan on 2020/3/12.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

//TODO:允许在一个session中存在多种cell类型，需要提供cellViewModelMProtocol解决，统一共用的必要接口
protocol MVVMListSecCellViewModelProtocol {
    // 因为sessionVM已经确定了单个的scellVM的方式，所以：identifier可以由sessionVM提供，并且生成数据的方式不需要统一成一个接口
    init(itemData: Any)
    var identifier: String { get }
    func didSelectCellViewModel(cellViewModel: Any, indexPath: IndexPath)
}

extension MVVMListSecCellViewModelProtocol {
    init(itemData: Any) {self.init(itemData: itemData)}
    var identifier: String {return ""}
    func didSelectCellViewModel(cellViewModel: Any, indexPath: IndexPath){}
}

//MARK:多种cellVM对应同一个cell，使用协议提供统一的接口来提供数据和事件
protocol MVVMListCourseCellViewModelProtocol: MVVMListSecCellViewModelProtocol {
    var title: String? { get }
}

extension MVVMListCourseCellViewModelProtocol {
    var title: String? {
       return ""
    }
}

class MVVMListListeningCellViewModel: NSObject, MVVMListSecCellViewModelProtocol {

    var model: MVVMListListeningModel?

    var identifier: String {
        return MVVMListListeningTableViewCell.identifier
    }

    func jump() {
        // 通过路由
        print("事件：跳转")
    }

    func click() {
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
