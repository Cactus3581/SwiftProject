//
//  MVVMListModel.swift
//  SwiftProject
//
//  Created by ryan on 2020/3/11.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit
import HandyJSON

class MVVMListModel: NSObject,HandyJSON {
    var order: Array<String>?
    var label: MVVMListLabelModel?
    var image: MVVMListImageModel?
    var button: MVVMListButtonModel?
    override required init() {}
}

class MVVMListLabelModel: NSObject,HandyJSON {
    var labelTitle: String?
    override required init() {}
}

class MVVMListImageModel: NSObject,HandyJSON {
    var imageUrl: String?
    override required init() {}
}

class MVVMListButtonModel: NSObject,HandyJSON {
    var buttonTitle: String?
    override required init() {}
}
