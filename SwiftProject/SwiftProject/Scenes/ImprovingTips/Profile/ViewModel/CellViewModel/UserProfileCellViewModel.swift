//
//  UserProfileCellViewModel.swift
//  SwiftProject
//
//  Created by ryan on 2020/3/12.
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

class UserProfileCommonCellViewModel:NSObject, UserProfileCellViewModelProtocol {
    
    var model: UserProfileCommonModel?
    
    var identifier: String {
        return UserProfileCommonTableViewCell.identifier
    }
}

//MARK:多种cellVM对应同一个cell，使用协议提供统一的接口来提供数据和事件
protocol UserProfilePhoneCellViewModelProtocol {
    func show(indexPath: NSIndexPath)
}

extension UserProfilePhoneCellViewModelProtocol {
    func show(indexPath: NSIndexPath) {}
}

class UserProfilePhoneCellViewModel: NSObject, UserProfilePhoneCellViewModelProtocol {
    
    @objc dynamic var model: UserProfilePhoneModel?
    var indexPath: NSIndexPath?
    
    func show(indexPath: NSIndexPath) {
        // 请求数据
        //成功
        self.model?.isShow = !(self.model?.isShow ?? false)
        self.indexPath = indexPath
    }

    func show1(indexPath: NSIndexPath, result: () -> Void) {
        // 请求数据
        //成功
        self.model?.isShow = !(self.model?.isShow ?? false)
        self.indexPath = indexPath
//        if let result = result {
            result()
//        }
    }

    
    var identifier: String {
        return UserProfileMultiDepartmentTableViewCell.identifier
    }
}

class UserProfileDepartmentCellViewModel: NSObject, UserProfileCellViewModelProtocol {
    
    var model: UserProfileDepartmentItemModel?
    
    var identifier: String {
        return UserProfileMultiDepartmentTableViewCell.identifier
    }
}
