//
//  BPModel.swift
//  SwiftProject
//
//  Created by ryan on 2020/1/15.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit
import HandyJSON

class BPModel: NSObject, HandyJSON {
    var label: BPLabelModel?
    var image: BPImageModel?
    var button: BPButtonModel?
    var order: Array<String>?
    required override init() {}
}

class BPLabelModel: NSObject, HandyJSON {
    required override init() {}
    var title: String?
    var list: [BPCommotModel]?
}

class BPImageModel: NSObject, HandyJSON {
    required override init() {}
    var imageUrl: String?
    var list: [BPCommotModel]?
}

class BPButtonModel: NSObject, HandyJSON {
    required override init() {}
    var jump: String?
    var list: [BPCommotModel]?
}

class BPCommotModel: NSObject, HandyJSON {
    required override init() {}
    var name: String?
}

// 构建cellvm的工作是在工厂里
// 构建cell/header 现在是依赖vm
// cell.
// sessionViewModel 与 ViewModel，拥有一个数组
// [type1,type2]，2种cell就得有两个vm，或者说至少。这个的意思是说tableView需要用到这两种，
// [{"type1":[]},{"type2":[]}]
