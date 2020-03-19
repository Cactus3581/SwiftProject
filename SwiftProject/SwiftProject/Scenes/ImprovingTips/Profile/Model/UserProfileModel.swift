//
//  UserProfileModel.swift
//  SwiftProject
//
//  Created by ryan on 2020/3/11.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit
import HandyJSON

class UserProfileModel: NSObject,HandyJSON {
    var order: Array<String>?
    var header: UserProfileListeningModel?
    var footer: UserProfileListeningModel?
    var listening: UserProfileListeningModel? // section1、cell1，标准
    var ads: UserProfileListeningModel? // section1、cell1，标准
    var circle: UserProfileListeningModel? // section2、cell1，测试同样的cell，不同的sessionView
    var speak: UserProfileSpeakModel? // section1、cell2 测试不同的cell，相同的sessionView + 测试多种cellVM对应同一个cell
    var course: UserProfileCourseModel?// section2、cell2，测试不同的cell，不同的sessionView + 测试多种sessionVM对应同一个sessionView
    var group: String? // 测试在一个session中存在多种cell
    var exam: String?
    var iap: String?
    var xmPush: String?
    var bookCatalogue: String?

    var list: Array<UserProfileSessionModel>?
    var ctaList: Array<UserProfileCTAItemModel>?
    override required init() {}
}

class UserProfileCTAItemModel: NSObject,HandyJSON {
    var type: String?
    var title: String?
    var imageUrl: String?
    var routeUrl: Array<Any>?
    override required init() {}
}

class UserProfileSessionModel: NSObject,HandyJSON {
    var type: String?
    var header: UserProfileListeningModel?
    var list: Array<Any>?
    override required init() {}
}

// listen
class UserProfileListeningModel: NSObject,HandyJSON {
    var title: String?
    override required init() {}
}

// speak
class UserProfileSpeakModel: NSObject,HandyJSON {
    var list: Array<UserProfileSpeakItemModel>?
    override required init() {}
}

class UserProfileSpeakItemModel: NSObject,HandyJSON {
    var speakScore: String?
    override required init() {}
}

// course
class UserProfileCourseModel: NSObject,HandyJSON {
    var list: Array<UserProfileCourseItemModel>?
    override required init() {}
}

class UserProfileCourseItemModel: NSObject,HandyJSON {
    var courseName: String?
    var courseTeacher: String?
    override required init() {}
}
