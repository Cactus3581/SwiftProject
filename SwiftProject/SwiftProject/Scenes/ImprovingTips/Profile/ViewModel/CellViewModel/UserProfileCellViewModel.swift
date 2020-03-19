//
//  UserProfileCellViewModel.swift
//  SwiftProject
//
//  Created by 夏汝震 on 2020/3/12.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

//TODO:允许在一个session中存在多种cell类型，需要提供cellViewModelMProtocol解决，统一共用的必要接口
protocol UserProfileCellViewModelProtocol {
    // 因为sessionVM已经确定了单个的scellVM的方式，所以：identifier可以由sessionVM提供，并且生成数据的方式不需要统一成一个接口
    init(itemData: Any)
    var identifier: String { get }
}

extension UserProfileCellViewModelProtocol {
    init(itemData: Any) {self.init(itemData: itemData)}
    var identifier: String {return ""}
}

//MARK:多种cellVM对应同一个cell，使用协议提供统一的接口来提供数据和事件
protocol UserProfileCourseCellViewModelProtocol {
    var title: String? { get }
}

extension UserProfileCourseCellViewModelProtocol {
    var title: String? {
       return ""
    }
}

class UserProfileListeningCellViewModel: NSObject {

    var model: UserProfileListeningModel?

    var identifier: String {
        return UserProfileListeningTableViewCell.identifier
    }

    func jump() {
        // 通过路由
        print("事件：跳转")
    }

    func click() {
        print("事件：点击")
    }

    func updateData(result: ((UserProfileListeningCellViewModel) -> ())) {
        // 数据更新
        result(self)
    }
}

class UserProfileSpeakCellViewModel: UserProfileCourseCellViewModelProtocol {

    var model: UserProfileSpeakItemModel?

    var title: String? {
        return model?.speakScore
    }

    var identifier: String {
        return UserProfileCourseTableViewCell.identifier
    }
}

class UserProfileCourseCellViewModel: UserProfileCourseCellViewModelProtocol {

    var model: UserProfileCourseItemModel?
    
    var title: String? {
        return model?.courseName
    }

    var identifier: String {
        return UserProfileCourseTableViewCell.identifier
    }
}
