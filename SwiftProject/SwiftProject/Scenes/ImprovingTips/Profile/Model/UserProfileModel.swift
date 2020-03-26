//
//  UserProfileModel.swift
//  SwiftProject
//
//  Created by ryan on 2020/3/11.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit
import HandyJSON

class UserProfileModel: NSObject, HandyJSON {
    var userInfo: UserInfo?// CTA之上区域展示的数据，用户信息
    var ctaInfo: CTAInfo?// CTA数据
    var profileInfo: ProfileInfo?// CTA之下区域的数据
    override required init() {}
}

//CTA之上区域
//工作状态
class WorkStatus: NSObject, HandyJSON {
    var status: Int?// 工作状态, 默认:0；请假:1；开会:2
    var description1: String?// 工作状态描述
    var startTime: Double?// 开始时间, 单位 秒
    var endTime: Double?// 结束时间
    override required init() {}
}

//用户信息
class UserInfo: NSObject, HandyJSON {
    var userName: String?   // i18n name
    var gender: String?    // 性别
    var city: String?      // i18n name
    var isFriend: Bool? // 是否好友
    var isResign: Bool? // 是否离职
    var tenantName: String? // i18n name
    var isNotDisturb: Bool?  // true为勿扰模式
    var workStatus: WorkStatus?
    var isAdmin: Bool?
    override required init() {}
}

//Profile基础类型
//包括type（类型）和 key（字段名）
class BaseProfileItem: NSObject, HandyJSON {
    var type: Int?
    var key: String?
    override required init() {}
}

//CTA区域
//CTA区域的项可以enable、disable
//CTA基础类型
class BaseCTAProfileItem: BaseProfileItem {
    var enable: Bool?
    required init() {}
}

//链接类型（扩展类型，(type = 1）
class CTALinkItem: BaseCTAProfileItem {
    var url: String?
    required init() {}
}

//查看消息类型/查看历史消息类型（type=2）
class CTAOpenChatItem: BaseCTAProfileItem {
    var chatterId: String?
    required init() {}
}

//语音类型 ( type = 3)
class CTAPhoneItem: BaseCTAProfileItem {
    var chatterId: String?
    required init() {}
}

//视频类型 ( type = 4)
class CTAVideoItem: BaseCTAProfileItem {
    var chatterId: String?
    required init() {}
}

//密聊类型 ( type = 5)
class CTASecretChatItem: BaseCTAProfileItem {
    var chatterId: Bool?
    required init() {}
}

//CTA数据结构
class CTAInfo: NSObject, HandyJSON  {
    var chat: CTAOpenChatItem?
    var phone: CTAPhoneItem?
    var video: CTAVideoItem?
    var secretChat: CTASecretChatItem?
    var linkItems: Array<CTALinkItem>?
    var orders: Array<String>? // item顺序
    override required init() {}
}

//CTA之下区域
// 文本类型:1； 链接类型:2； 部们:3；手机:4；leader:5；状态:6；alias(备注):7
//普通文本类型（扩展类型）( type = 1)
class TextItem: BaseProfileItem {
    var value: String?
    required init() {}
}

//链接类型（扩展类型）( type = 2)
class LinkItem: BaseProfileItem {
    var linkTitle: String?
    var url: String?   // https:// 或 lark:// 协议的url
    required init() {}
}

//部门类型 ( type = 3)
//部门元数据
class DepartmentMeta: NSObject, HandyJSON {
    var id: String?
    var name: String?
    override required init() {}
}

//全部门路径元数据
class DepartmentsMeta: NSObject, HandyJSON  {
    var id: String?
    var departments: Array<DepartmentMeta>?
    var path: String?
    override required init() {}
}

//全部门数据
class DepartmentsItem: BaseProfileItem {
    var departments: Array<DepartmentsMeta>?
    required init() {}
}

//电话类型 ( type = 4)
class PhoneItem: BaseProfileItem {
    var state: Int? // 隐藏:1；受限:2；公开:3
    var number: String?
    required init() {}
}

//备注类型( type = 5)
class AliasItem: BaseProfileItem {
    var alias: String? // 备注
    required init() {}
}

//用户状态类型( type = 6)
class UserStatusItem: BaseProfileItem {
    var status: Int? // default:0；出差:1；请假:2；开会:3
    var statusInfo: String?
    required init() {}
}

//CTA之下数据结构
class ProfileInfo : NSObject, HandyJSON {
    var departments:DepartmentsItem?
    var phone: PhoneItem?
    var alias: AliasItem?
    var userStatus: UserStatusItem?
    var textItems: Array<TextItem>?
    var linkItems: Array<LinkItem>?
    var orders: Array<String>?
    override required init() {}
}

//三个点
class ProfileThreePointsInfo : NSObject, HandyJSON {
    var type: String?
    var title: String?
    override required init() {}
}
