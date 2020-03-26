//
//  UserProfileCellViewModel.swift
//  SwiftProject
//
//  Created by ryan on 2020/3/12.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

// 因为现在默认一种session只有一种cell，所以不需要协议来抽象

class UserProfilePhoneCellViewModel: NSObject {
    @objc dynamic var model: PhoneItem?
    var indexPath: IndexPath?
    var isShow: Bool? = false

    func show(indexPath: IndexPath) {
        // 请求数据
        // 成功
        //self.model?.isShow = !(self.model?.isShow ?? false)
        self.indexPath = indexPath
    }

    func show1(indexPath: IndexPath, result: () -> Void) {
        // 请求数据
        // 成功
        self.isShow = !(self.isShow ?? false)
        self.indexPath = indexPath
        //if let result = result {
            result()
        //}
    }
}

class UserProfileDepartmentCellViewModel: NSObject {
    var model: DepartmentsMeta?
    var path: String?
}

class UserProfileAliasCellViewModel: NSObject {
    var model: AliasItem?
}

class UserProfileUserStatusCellViewModel: NSObject {
    var model: UserStatusItem?
}

class UserProfileTextCellViewModel: NSObject {
    var model: TextItem?
}

class UserProfileLinkCellViewModel: NSObject {
    var model: LinkItem?
}
