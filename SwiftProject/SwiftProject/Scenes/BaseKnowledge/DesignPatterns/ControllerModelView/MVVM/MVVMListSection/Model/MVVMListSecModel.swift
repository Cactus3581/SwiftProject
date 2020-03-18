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
    var header: String?
    var footer: String?
    var listening: MVVMListListeningModel? // section1、cell1，标准
    var listeningSame: MVVMListListeningModel? // section1、cell1，标准
    var circle: MVVMListListeningModel? // section2、cell1，测试同样的cell，不同的sessionView
    var speak: MVVMListSpeakModel? // section1、cell2 测试不同的cell，相同的sessionView + 测试多种cellVM对应同一个cell
    var course: MVVMListCourseModel?// section2、cell2，测试不同的cell，不同的sessionView + 测试多种sessionVM对应同一个sessionView
    var group: MVVMListSpeakModel? // 测试在一个session中存在多种cell
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

// group
class MVVMListGroupModel: NSObject,HandyJSON {
    var list: Array<MVVMListSpeakItemModel>?
    override required init() {}
}
