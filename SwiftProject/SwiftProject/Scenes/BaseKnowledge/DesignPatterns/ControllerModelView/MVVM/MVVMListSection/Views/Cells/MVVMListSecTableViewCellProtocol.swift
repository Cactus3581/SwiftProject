//
//  MVVMListSecBaseTableViewCell.swift
//  SwiftProject
//
//  Created by 夏汝震 on 2020/3/11.
//  Copyright © 2020 cactus. All rights reserved.
//

import UIKit

protocol MVVMListSecTableViewCellProtocol {
    var cellViewModel: Any? { set get }// 提供赋值方式
    static var identifier: String { get }// 注册的时候用
}

extension MVVMListSecTableViewCellProtocol {
    var cellViewModel: Any? { set{} get{return nil} }
    static var identifier: String { return "" }
}
