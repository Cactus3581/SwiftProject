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
    var listening: MVVMListListeningModel?
    var course: MVVMListCourseModel?
//    var plain: MVVMListCourseModel?
//    var plaain: MVVMListListeningModel?
    override required init() {}
}

class MVVMListListeningModel: NSObject,HandyJSON {
    var headerText: String?
    var footerText: String?
    var ListeningName: String?
    override required init() {}
}

class MVVMListCourseModel: NSObject,HandyJSON {
    var headerImageUrl: String?
    var footerImageUrl: String?
    var list: Array<MVVMListCourseItemModel>?
    override required init() {}
}

class MVVMListCourseItemModel: NSObject,HandyJSON {
    var courseName: String?
    var courseTeacher: String?
    override required init() {}
}
