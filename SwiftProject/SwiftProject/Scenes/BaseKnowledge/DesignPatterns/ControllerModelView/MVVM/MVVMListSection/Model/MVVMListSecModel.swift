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
    var button: MVVMListSecButtonModel?
    var sec: MVVMListSectionModel?
    override required init() {}
}

class MVVMListSecButtonModel: NSObject,HandyJSON {
    var buttonTitle: String?
    override required init() {}
}

class MVVMListSectionModel: NSObject,HandyJSON {
    var list: Array<String>?
    override required init() {}
}
