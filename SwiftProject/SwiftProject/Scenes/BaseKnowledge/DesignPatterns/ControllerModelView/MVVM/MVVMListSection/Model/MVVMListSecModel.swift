//
//  MVVMListSecModel.swift
//  SwiftProject
//
//  Created by ryan on 2020/3/11.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit
import HandyJSON

class MVVMListSecModel: NSObject,HandyJSON {
    var order: Array<String>?
    var header: MVVMListListeningModel?
    var footer: MVVMListListeningModel?
    var listening: MVVMListListeningModel? // section1、cell1，标准
    var ads: MVVMListListeningModel? // section1、cell1，标准
    var circle: MVVMListListeningModel? // section2、cell1，测试同样的cell，不同的sessionView
    var speak: MVVMListSpeakModel? // section1、cell2 测试不同的cell，相同的sessionView + 测试多种cellVM对应同一个cell
    var course: MVVMListCourseModel?// section2、cell2，测试不同的cell，不同的sessionView + 测试多种sessionVM对应同一个sessionView
    var group: String? // 测试在一个session中存在多种cell
    var exam: String?
    var iap: String?
    var xmPush: String?
    var bookCatalogue: String?

    var list: Array<MVVMListSessionModel>?
    override required init() {}
}

class MVVMListSessionModel: NSObject,HandyJSON {
    var type: String?
    var header: MVVMListListeningModel?
    var list: Array<Any>?
    override required init() {}
}

// listen
class MVVMListListeningModel: NSObject,HandyJSON {
    var title: String?
    override required init() {}
}

// speak
class MVVMListSpeakModel: NSObject,HandyJSON {
    var list: Array<MVVMListSpeakItemModel>?
    override required init() {}
}

class MVVMListSpeakItemModel: NSObject,HandyJSON {
    var speakScore: String?
    override required init() {}
}

// course
class MVVMListCourseModel: NSObject,HandyJSON {
    var list: Array<MVVMListCourseItemModel>?
    override required init() {}
}

class MVVMListCourseItemModel: NSObject,HandyJSON {
    var courseName: String?
    var courseTeacher: String?
    override required init() {}
}
