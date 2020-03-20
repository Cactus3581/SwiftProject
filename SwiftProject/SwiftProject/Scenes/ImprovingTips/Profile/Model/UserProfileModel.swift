//
//  UserProfileModel.swift
//  SwiftProject
//
//  Created by ryan on 2020/3/11.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit
import HandyJSON

enum FieldType: Int {
    case UNKNOWN
    case DEFAULT
    case CUSTOM
}

enum FieldValueType: Int {
    case UNKNOWN
    case TEXT
    case HREF
}

class UserProfileModel: NSObject,HandyJSON {
    var order: Array<String>?
    var info: UserProfileInfoModel?
    var ctaList: Array<UserProfileCTAItemModel>?
    var job: UserProfileCommonModel?
    var personalStatus: UserProfileCommonModel?
    var phone: UserProfilePhoneModel?
    var department: Array<UserProfileDepartmentItemModel>?
    var nickName: UserProfileNickNameModel?
    override required init() {}
}

// CTA以上区域
class UserProfileInfoModel: NSObject,HandyJSON {
    var name: String?
    var tags: Array<String>?
    var company: String?
    var timeZone: String?
    override required init() {}
}

// CTA区域
class UserProfileCTAItemModel: NSObject,HandyJSON {
    var type: String?
    var title: String?
    var imageUrl: String?
    var routeUrl: Array<Any>?
    override required init() {}
}

// CTA下 Cell区域
// 通用
class UserProfileCommonModel: NSObject,HandyJSON {
    var title: String?
    override required init() {}
}

// 电话
class UserProfilePhoneModel: NSObject,HandyJSON {
    var phone: String?
    var code: String?
    @objc dynamic var isShow: Bool = false
    override required init() {}
}

// 部门
class UserProfileDepartmentItemModel: NSObject,HandyJSON {
    var type: String?
    var title: String?
    override required init() {}
}

// 备注
class UserProfileNickNameModel: NSObject,HandyJSON {
    var nickName: String?
    override required init() {}
}

